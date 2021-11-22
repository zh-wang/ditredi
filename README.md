DiTreDi
===========

A flutter package that displays large 3D datasets on transparent canvas.

## Preface

DiTreDi was created to efficiently display datasets and meshes in 3D space. It wasn't intended to create a 3D game engine and is rather useful for displaying static meshes.

## Getting started

[Install package](https://pub.dev/packages/ditredi/install).

Add imports for `ditredi` and `vector_math`:

```dart
import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';
```

Add `DiTreDi` widget to your tree:

```dart
DiTreDi(
    figures: [
        Cube3D(2, Vector3(0, 0, 0)),
    ],
)
```

And voilà, single cube will be displayed:

![Cube3D](test/paint/golden/cube/default.png)

> Note: `DiTreDi` takes full available size. Wrap in `SizedBox` or `Expanded` to control its constraints and size.

## Controller

`DiTreDiController` controls a scene rotation, scale, light.

To setup controller, keep its reference in a state and pass to `controller` parameter.

```dart
// in a state
@override
void initState() {
    super.initState();
    controller = DiTreDiController();
}

DiTreDi(
    figures: [
        Cube3D(2, Vector3(0, 0, 0)),
    ],
    controller: controller,
)
```

Once ready, update controller state by calling:

```dart
controller.update(rotationY: 30, rotationX: 30);
```

![Cube3D](test/paint/golden/cube/rotated.png)

To handle input gestures use `GestureDetector` or `DiTreDiDraggable`:

```dart
DiTreDiDraggable(
    controller: controller,
    child: DiTreDi(
        figures: [Cube3D(1, vector.Vector3(0, 0, 0))],
        controller: controller,
    ),
);
```

## Config

`DiTreDiConfig` defines component "defaults" - mesh color, lines and points width (if not specified).

```dart
// in a state

DiTreDi(
    figures: [
        Cube3D(2, Vector3(0, 0, 0)),
    ],
    config: DiTreDiConfig(
        supportZIndex: false,
    ),
)
```

If a huge dataset is displayed and you don't bother about paint order, it's recommended to disable z-index which boosts drawing speed (`supportZIndex = false`).

## Shapes

`DiTreDi` out-of-the-box supports shapes like:

### Cube3D

Just a cube.

```dart
DiTreDi(
    figures: [
        Cube3D(2, Vector3(0, 0, 0)),
    ],
)
```

![Cube3D](test/paint/golden/cube/default.png)

### Face3D

Face (aka triangle).

```dart
DiTreDi(
    figures: [
        Face3D(
            Triangle.points(
                Vector3(0, 0 - 1, 0 - 1),
                Vector3(0, 0 - 1, 0 + 1),
                Vector3(0, 0 + 1, 0 + 1),
            ),
        ),
    ],
)
```

![Face3D](test/paint/golden/face_3d/triangle.png)

### Group3D

Groups a list of figures.

```dart
DiTreDi(
    figures: [
        Group3D([
            Cube3D(1, Vector3(0, 0, 0)),
            Cube3D(1, Vector3(3, 3, 3)),
        ]),
    ],
)
```

![Group3D](test/paint/golden/group_3d/cubes.png)

An alternative method to display multiple shapes, it to put a few `figures`:

```dart
DiTreDi(
    figures: [
        Cube3D(1, Vector3(0, 0, 0)),
        Cube3D(1, Vector3(-3, 0, 0)),
        Cube3D(1, Vector3(3, 0, 0)),
        Cube3D(1, Vector3(0, -3, 0)),
        Cube3D(1, Vector3(0, 3, 0)),
        Cube3D(1, Vector3(0, 0, -3)),
        Cube3D(1, Vector3(0, 0, 3)),
    ],
)
```

![Multiple figures](test/paint/golden/ditredi/multiple.png)

### Line3D

A line.

```dart
DiTreDi(
    figures: [
      Line3D(Vector3(0, 1, 0), Vector3(2, 1, 4), width: 8),
      Line3D(Vector3(0, 2, 0), Vector3(2, 2, 4), width: 6),
      Line3D(Vector3(0, 3, 0), Vector3(2, 3, 4), width: 4),
      Line3D(Vector3(0, 4, 0), Vector3(2, 4, 4), width: 2),
      Line3D(Vector3(0, 5, 0), Vector3(2, 5, 4), width: 1),
    ],
)
```

![Line3D](test/paint/golden/line_3d/width.png)

### Mesh3D

Mesh made of faces (triangles).
You could use `ObjParser` to load it from .obj file contents.

```dart
DiTreDi(
    figures: [
        Mesh3D(await ObjParser().parse(meshLines));
    ],
)
```

![Torus](test/paint/golden/mesh_3d/torus.png)
![Terrain](test/paint/golden/mesh_3d/terrain.png)

### Plane3D

Plane facing x, y or z axis.

```dart
DiTreDi(
    figures: [
        Plane3D(5, Axis3D.y, false, Vector3(0, 0, 0), color: Colors.green),
    ],
)
```

![Plane3D](test/paint/golden/plane_3d/y.png)

### Point3D

A point (really, a square).

```dart
DiTreDi(
    figures: [
        Plane3D(5, Axis3D.y, false, Vector3(0, 0, 0), color: Colors.green),
    ],
)
```

![Plane3D](test/paint/golden/point_3d/bold.png)

### PointPlane3D

Plane made of points (e.g. to show an object) scale.

```dart
DiTreDi(
    figures: [
      PointPlane3D(1, Axis3D.y, 0.1, Vector3(0, 0, 0), pointWidth: 5),
      Cube3D(0.5, Vector3(0, 0, 0)),
    ],
)
```

![PointPlane3D](test/paint/golden/point_plane_3d/bold.png)