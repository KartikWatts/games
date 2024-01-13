import { Point, Section } from "../../logic/types.ts";
import { useCallback } from "react";
import { Graphics as PixiGraphics } from "@pixi/graphics";
import { sectionLineWidth } from "./drawConfig.ts";
import { arcRadius } from "../../logic/updatePlaying/getNextSection.ts";
import { Graphics } from "@pixi/react";

export function DrawSection({
  section,
  scale,
  point,
}: {
  section: Section;
  scale: number;
  point: Point;
}) {
  const draw = useCallback(
    (g: PixiGraphics) => {
      g.clear();
      g.beginFill("red");
      g.drawRect(point.x * scale, point.y * scale, 20 * scale, 20 * scale);
      g.endFill();
    },
    [scale, point]
  );

  return <Graphics draw={draw} />;
}
