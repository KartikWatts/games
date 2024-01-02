import { Section } from "../../logic/types.ts";
import { useCallback } from "react";
import { Graphics as PixiGraphics } from "@pixi/graphics";
import { sectionLineWidth } from "./drawConfig.ts";
import { arcRadius } from "../../logic/updatePlaying/getNextSection.ts";
import { Graphics } from "@pixi/react";

export function DrawSection({
  section,
  scale,
}: {
  section: Section;
  scale: number;
}) {
  const draw = useCallback(
    (g: PixiGraphics) => {
      g.clear();
      g.beginFill("red");
      g.drawRect(section.start.x * scale, section.start.y * scale, 20, 20);
      g.endFill();
    },
    [section, scale]
  );

  return <Graphics draw={draw} />;
}
