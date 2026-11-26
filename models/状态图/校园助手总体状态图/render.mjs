import { readFileSync, writeFileSync } from "node:fs";
import { render } from "pele";

const diagramPath = process.argv[2];
const diagram = readFileSync(diagramPath, "utf8");
const { svg } = render(diagram, { limit: 1_000_000, outputLimit: 8_000_000, maxEdges: 10_000 });
const theme = `<style>
  .pele {
    --pele-font: "PingFang SC", "Noto Sans CJK SC", "Microsoft YaHei", sans-serif;
    --pele-bg: #ffffff;
    --pele-fg: #172a40;
    --pele-muted: #52677f;
    --pele-line: #607991;
    --pele-surface: #f4f8fc;
    --pele-surface-alt: #edf3f8;
    --pele-border: #adbfce;
  }
  @media (prefers-color-scheme: dark) {
    .pele {
      --pele-bg: #182331;
      --pele-fg: #ecf2fa;
      --pele-muted: #b1c1d4;
      --pele-line: #a0b7ce;
      --pele-surface: #23364b;
      --pele-surface-alt: #213044;
      --pele-border: #557088;
    }
  }
</style><rect width="100%" height="100%" fill="var(--_bg)"/>`;
writeFileSync(diagramPath.replace(/\.mmd$/, ".svg"), svg.replace(/^(<svg[^>]*>)/, `$1${theme}`));
