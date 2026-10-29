# CityView

An isometric, hand-composed, painted view of a city-state (720 × 540). It consists of fewer but detailed buildings: every building is a real 3D mass with two visible walls and a roof, lit from the top left.

**Building details:**

- Roofs: gable, hip and pyramid roofs, tile, slate and thatch covering in rows, with ridges and bargeboards, dormer windows.
- Walls: stonework, half-timbered and jettied upper floors, plaster, planks.
- Openings: shuttered, arched and leaded-glass windows, flower boxes, plank doors with handles, shop awnings, signs, balconies.
- Chimneys with smoke, cast shadows.

**Districts:**

- **Town Hall:** a domed parliament with a colonnade and pediment, two wings, a clock tower, a formal garden with a fountain.
- **Marketplace:** market hall, stalls, guild hall, well, carts, a chapel with a bell tower, a smithy.
- **Underworld:** night tone, ramshackle houses, an inn with lanterns, a ruined tower, fog.

**Walls and surroundings:** a crenellated city wall with round towers, gate towers with portcullises, a moat with bridges; fields, pasture, barn, windmill, quarry, a river with a stone bridge, or a port.

**What the caller provides:** `name`, `coast`, `stability`, `districts`, `selected`, `onSelect(key)`.

- Use it in a `MapViewport`, with `aspect="720 / 540"` and 1.8× zoom.
