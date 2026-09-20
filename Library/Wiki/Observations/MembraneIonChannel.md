# Cell Membrane Gated Ion Channel ($\text{Na}^+/\text{K}^+$ Pump) Multi-Biochemistry Observation

## Overview & Theoretical Foundation

Voltage-gated ion channels ($\text{Na}^+, \text{K}^+, \text{Ca}^{2+}$) and active ATP-driven pumps maintain the resting potential ($\Delta V \approx -70\text{ mV}$) across cell membranes, enabling nerve action potential propagation (Hodgkin & Huxley, Nobel 1963).

In discrete geometry, gated ion transport is modeled as:
- **`EM.Calculus`**: Electric potential gradient $\vec{E} = -\nabla \Phi$ across the lipid bilayer.
- **`Boole`**: Channel gate state (`Zero` = closed, `One` = open).
- **`Substrate`**: Ion transport causal edges across membrane nodes.

```
  ┌───────────────────────────┬──────────────────────────────────────┬──────────────────────────────────────────┐
  │ Membrane Channel State    │ Closed Gate (Resting Potential)      │ Open Gate (Ion Conductance Pulse)        │
  ├───────────────────────────┼──────────────────────────────────────┼──────────────────────────────────────────┤
  │ 1. Boole                  │ Channel gate bit = Zero (closed)     │ Channel gate bit = One (open)            │
  │ 2. Electromagnetism       │ Potential gradient Phi_in - Phi_out  │ Depolarisation ion flux GaugeField       │
  │ 3. Substrate              │ No ion edge across membrane          │ Trans-membrane ion edge (substrateLag=1) │
  │ 4. Chromogeometry         │ Intra-membrane distance Q = 25       │ Conducted ion quadrance Q = 25           │
  └───────────────────────────┴──────────────────────────────────────┴──────────────────────────────────────────┘
```

---

## Executable Literate Idris2 Observation Code

```idris
module Wiki.Observations.MembraneIonChannel

import Core
import Geometry
import Chemistry
import Data.Vect

%default total

-----------------------------------------------------------------------
-- 1. MEMBRANE ION CHANNEL STATE DEFINITIONS
-----------------------------------------------------------------------

||| Empty Maxel helper
public export
emptyMaxel : Core.VexelMaxel.Maxel
emptyMaxel = MkMaxel []

||| Check if Maxel is empty
public export
isMaxelEmpty : Core.VexelMaxel.Maxel -> Bool
isMaxelEmpty (MkMaxel []) = True
isMaxelEmpty _            = False

||| Voltage-gated membrane ion channel state.
public export
record MembraneChannelState where
  constructor MkMembraneChannel
  gateOpen         : Bool         -- False = closed gate, True = open gate
  membranePotential: BoxInt       -- Bilayer potential field Phi
  ionTransportMaxel: Core.VexelMaxel.Maxel        -- Ion conductance maxel

-----------------------------------------------------------------------
-- 2. CANONICAL STATES & GATE OPENING TRANSITION
-----------------------------------------------------------------------

||| Closed ion channel at resting potential (-70 mV).
public export
canonicalClosedChannel : MembraneChannelState
canonicalClosedChannel =
  MkMembraneChannel False (intToBoxInt (-70)) emptyMaxel

||| Opens the ion channel gate (depolarisation).
public export
openChannelGate : MembraneChannelState -> MembraneChannelState
openChannelGate closed =
  let vNa = intToBoxInt 60
      vK  = intToBoxInt (-90)
      phi = hodgkinHuxleyPotential vNa vK
      ionMaxel = bondsToMaxel [MkCovalentBond 1 2 1]
  in MkMembraneChannel True phi ionMaxel

-----------------------------------------------------------------------
-- 3. VERIFIED MEMBRANE ION CHANNEL INVARIANT PROPERTIES
-----------------------------------------------------------------------

||| Property 1: Gate opening flips Boolean state from False -> True.
public export
prop_gateBitOpensOnDepolarisation : Bool
prop_gateBitOpensOnDepolarisation =
  let openCh = openChannelGate canonicalClosedChannel
  in (not canonicalClosedChannel.gateOpen) && openCh.gateOpen

||| Property 2: Trans-membrane ion conductance forms non-empty maxel.
public export
prop_ionConductanceFormsSubstrateEdge : Bool
prop_ionConductanceFormsSubstrateEdge =
  let openCh = openChannelGate canonicalClosedChannel
  in (not (isMaxelEmpty openCh.ionTransportMaxel))

||| Property 3: Closed channel has empty maxel.
public export
prop_closedChannelHasZeroLag : Bool
prop_closedChannelHasZeroLag =
  isMaxelEmpty canonicalClosedChannel.ionTransportMaxel

-----------------------------------------------------------------------
-- 4. SUITE EXECUTION
-----------------------------------------------------------------------

||| Runs complete Membrane Ion Channel Observation Suite.
public export
runMembraneIonChannelSuite : Bool
runMembraneIonChannelSuite =
  prop_gateBitOpensOnDepolarisation &&
  prop_ionConductanceFormsSubstrateEdge &&
  prop_closedChannelHasZeroLag
```
