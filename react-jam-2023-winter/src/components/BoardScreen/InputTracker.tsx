import { useAtomValue } from "jotai";
import { useState, useEffect, RefObject } from "react";
import { $ready } from "../../state/state.ts";
import { Point } from "../../logic/types.ts";

// https://stackoverflow.com/a/4819886
function isTouchDevice() {
  return (
    "ontouchstart" in window ||
    navigator.maxTouchPoints > 0 ||
    navigator.maxTouchPoints > 0
  );
}

export function InputTracker({
  containerRef,
  scale,
}: {
  containerRef: RefObject<HTMLDivElement>;
  scale: number;
}) {
  const ready = useAtomValue($ready);
  const [point, setPoint] = useState<Point>({ x: 0, y: 0 });

  const containerDimensions: DOMRect | undefined =
    containerRef?.current?.getBoundingClientRect();

  useEffect(() => {
    function onTouch(e: TouchEvent) {
      e.preventDefault();
      const touches = [...e.touches];
      const finalTouch = touches[touches.length - 1];
      setPoint({ x: finalTouch.clientX, y: finalTouch.clientY });
    }

    function onMouseDown(e: MouseEvent) {
      console.log(e);
      setPoint({ x: e.clientX, y: e.clientY });
    }

    if (isTouchDevice()) {
      document.body.addEventListener("touchstart", onTouch);
    } else {
      document.body.addEventListener("mousedown", onMouseDown);
    }

    return () => {
      if (isTouchDevice()) {
        document.body.removeEventListener("touchstart", onTouch);
      } else {
        document.body.removeEventListener("mousedown", onMouseDown);
      }
    };
  }, []);

  useEffect(() => {
    if (!ready || !containerDimensions) return;

    if (point.x !== 0 && point.y !== 0) {
      const { x, y } = getDimensions(
        point.x,
        point.y,
        scale,
        containerDimensions
      );
      Rune.actions.setPoint({
        x,
        y,
      });
    } else {
      Rune.actions.setPoint({ x: 0, y: 0 });
    }
    console.log(point);
  }, [ready, containerDimensions, scale, point]);

  return null;
}

const getDimensions = (
  pointX: number,
  pointY: number,
  scale: number,
  containerDimensions: DOMRect
) => {
  let x = Math.min(
    pointX - 30 + pointX * scale - containerDimensions.left,
    containerDimensions.width + containerDimensions.width * scale
  );
  let y = pointY;
  return { x, y };
};
