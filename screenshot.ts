import path from 'path';
import fs from 'fs';
import { exec, execSync } from 'child_process';

const FONT_SIZE = process.env.FONT_SIZE as string;
const FONTS_DIR = process.env.FONTS_DIR as string;
const TERMINATOR_BASE_CONFIG = process.env.TERMINATOR_BASE_CONFIG as string;
const TERMINATOR_TEMP_CONFIG = process.env.TERMINATOR_TEMP_CONFIG as string;
const SCREENSHOT_DIR = process.env.SCREENSHOT_DIR as string;
const SAMPLE_SCREEN_SESSION_NAME = process.env
  .SAMPLE_SCREEN_SESSION_NAME as string;

class TerminatorConfig {
  readonly config: string;

  constructor(config: string) {
    this.config = config;
  }

  set(key: string, value: string): TerminatorConfig {
    const regexp = new RegExp(`( +)${key} = .+\n`, 'g');
    return new TerminatorConfig(
      this.config.replace(regexp, `$1${key} = ${value}\n`)
    );
  }
}

const sleep = (ms: number): Promise<void> =>
  new Promise(resolve =>
    setTimeout(() => {
      resolve();
    }, ms)
  );

const getTargetFontFamilies = async (): Promise<string[]> => {
  const font_files = fs
    .readdirSync(FONTS_DIR)
    .filter(x => x.indexOf('.ttf') !== -1 || x.indexOf('.ttc') !== -1);

  const scan_results = font_files.map(x =>
    execSync(`fc-scan "${path.join(FONTS_DIR, x)}"`).toString()
  );

  return Array.from(
    new Set(
      scan_results
        .map(x => x.match(/family: "(.+?)"/))
        .filter((x): x is RegExpMatchArray => x !== null)
        .map(x => x[1])
    )
  );
};

const terminatorScreenshot = async (
  config: TerminatorConfig,
  filename: string
): Promise<void> => {
  execSync(`./refresh_sample_screen.sh`);
  fs.writeFileSync(TERMINATOR_TEMP_CONFIG, config.config);

  const res = exec(
    `terminator -f --config ${TERMINATOR_TEMP_CONFIG} -pdefault -e '/bin/bash -c \"tmux a -t ${SAMPLE_SCREEN_SESSION_NAME}\"'`
  );
  await sleep(1500);
  execSync(`gnome-screenshot -f ${path.join(SCREENSHOT_DIR, filename)}`);

  const kill_target_pids = execSync(
    "ps aux | grep terminator | grep -v grep | cut -d ' ' -f 2"
  )
    .toString()
    .split('\n')
    .filter(x => x !== '')
    .map(x => parseInt(x));

  console.log('killing terminator processes', kill_target_pids);
  kill_target_pids.forEach(x => process.kill(x));

  await sleep(1000);
};

const main = async () => {
  try {
    fs.mkdirSync(SCREENSHOT_DIR);
  } catch (e) {}

  const target_font_families = await getTargetFontFamilies();
  const terminator_base_config = new TerminatorConfig(
    fs.readFileSync(TERMINATOR_BASE_CONFIG).toString()
  ).set('background_darkness', '1');

  for (const font_family of target_font_families) {
    await terminatorScreenshot(
      terminator_base_config.set('font', `${font_family} ${FONT_SIZE}`),
      `${font_family}.png`
    );
  }

  //cjk width
  for (const font_family of target_font_families) {
    await terminatorScreenshot(
      terminator_base_config
        .set(
          'enabled_plugins',
          `LaunchpadCodeURLHandler, APTURLHandler, CjkWidthWide, LaunchpadBugURLHandler`
        )
        .set('font', `${font_family} ${FONT_SIZE}`),
      `cjk-${font_family}.png`
    );
  }
};

main();
