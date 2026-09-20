# Enzyme Active Site Catalysis & Substrate Recognition Multi-Biochemistry Observation

## Overview & Theoretical Foundation

Enzyme catalysis (Emil Fischer 1894 lock-and-key, Daniel Koshland 1958 induced fit) accelerates biochemical reactions by factors of $10^6$ to $10^{17}$.

In discrete geometry, substrate-active site molecular recognition is represented as **Boolean XOR bit complementarity** paired with a **ChargeGate coordinate lock**:
- **Active Site Complementarity**: Substrate bit $b_S$ matches enzyme binding pocket bit $b_E$ iff $b_S \oplus b_E = \text{One}$.
- **Coordinate Lock**: Substrate binds at exact $Q = 25$ ChargeGate² quadrance distance from catalytic residues.
- **Catalytic Transition**: Lowers reaction barrier by forming an intermediate enzyme-substrate substrate graph edge.

```
  ┌───────────────────────────┬──────────────────────────────────────┬──────────────────────────────────────────┐
  │ Biochemical System        │ Unbound Enzyme + Substrate           │ Catalytic Enzyme-Substrate Complex       │
  ├───────────────────────────┼──────────────────────────────────────┼──────────────────────────────────────────┤
  │ 1. Boole                  │ Active site bit = One, Substrate = Zero│ Complementary pair XOR b_S ⊕ b_E = One │
  │ 2. Chromogeometry         │ Distance Q > 25 (unbound)            │ Active site lock Q = 25 (bound)          │
  │ 3. Substrate              │ Disjoint enzyme & substrate DAGs     │ Joined ES complex edge (substrateLag = 1)│
  │ 4. Trigonometry           │ Unconstrained substrate spread       │ Induced-fit transition spread s = 1/2    │
  └───────────────────────────┴──────────────────────────────────────┴──────────────────────────────────────────┘
```

---

## Executable Literate Idris2 Observation Code

```idris
module Wiki.Observations.EnzymeCatalysis

import Core.BoxInt
import Core.VexelMaxel
import Math.RationalTrig
import Compound.MolecularBonding
import Data.Vect

%default total

-----------------------------------------------------------------------
-- 1. ENZYME CATALYSIS STATE DEFINITIONS
-----------------------------------------------------------------------

||| Empty Maxel helper
public export
emptyMaxel : Maxel
emptyMaxel = MkMaxel []

||| Check if Maxel is empty
public export
isMaxelEmpty : Maxel -> Bool
isMaxelEmpty (MkMaxel []) = True
isMaxelEmpty _            = False

||| Enzyme active site and substrate complex state.
public export
record EnzymeComplexState where
  constructor MkEnzymeComplex
  activeSiteBit  : Bool              -- Active site binding pocket complement bit
  substrateBit   : Bool              -- Substrate key bit
  bindingQ       : BoxInt            -- Quadrance to active site
  esMaxel        : Maxel             -- Enzyme-Substrate complex adjacency maxel

-----------------------------------------------------------------------
-- 2. CANONICAL STATES & CATALYTIC BINDING
-----------------------------------------------------------------------

||| Unbound enzyme and substrate.
public export
canonicalUnboundEnzyme : EnzymeComplexState
canonicalUnboundEnzyme =
  MkEnzymeComplex True False (intToBoxInt 100) emptyMaxel

||| Binds substrate to active site: forms induced-fit ES complex.
public export
bindEnzymeSubstrate : EnzymeComplexState -> EnzymeComplexState
bindEnzymeSubstrate unbound =
  let qBound = intToBoxInt 25
      esBond = bondsToMaxel [MkCovalentBond 1 2 1]
  in MkEnzymeComplex unbound.activeSiteBit unbound.substrateBit qBound esBond

-----------------------------------------------------------------------
-- 3. VERIFIED ENZYME CATALYSIS INVARIANT PROPERTIES
-----------------------------------------------------------------------

||| Property 1: Substrate recognition is Boolean complementary.
public export
prop_activeSiteXORComplementary : EnzymeComplexState -> Bool
prop_activeSiteXORComplementary es =
  es.activeSiteBit /= es.substrateBit

||| Property 2: Bound ES complex locks at exact Q = 25 ChargeGate² quadrance.
public export
prop_esComplexLocksAtQ25 : EnzymeComplexState -> Bool
prop_esComplexLocksAtQ25 unbound =
  let bound = bindEnzymeSubstrate unbound
  in bound.bindingQ == intToBoxInt 25

||| Property 3: ES complex forms catalytic bond maxel.
public export
prop_esComplexFormsSubstrateEdge : EnzymeComplexState -> Bool
prop_esComplexFormsSubstrateEdge unbound =
  let bound = bindEnzymeSubstrate unbound
  in not (isMaxelEmpty bound.esMaxel)

-----------------------------------------------------------------------
-- 4. SUITE EXECUTION
-----------------------------------------------------------------------

||| Runs complete Enzyme Catalysis Observation Suite.
public export
runEnzymeCatalysisSuite : Bool
runEnzymeCatalysisSuite =
  let unbound = canonicalUnboundEnzyme
  in prop_activeSiteXORComplementary unbound &&
     prop_esComplexLocksAtQ25 unbound &&
     prop_esComplexFormsSubstrateEdge unbound
```
