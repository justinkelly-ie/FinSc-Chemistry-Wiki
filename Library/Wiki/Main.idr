module Wiki.Main

import Wiki.ChemistryScaleTransformSpec
import Chemistry
import Stage0.Chemistry.ReactionKinetics
import System

%default total

main : IO ()
main = do
  putStrLn "=========================================================================="
  putStrLn "   🧪 IDRIS2 DISCRETE CHEMISTRY WIKI VERIFICATION RUNNER 🧪"
  putStrLn "=========================================================================="
  putStrLn ""
  putStrLn "--- PART 1: CHEMISTRY ScaleTransform & ATOMIC NUMBER Z HOMOMORPHISM ---"
  p <- auditChemistryScaleTransformSpecProof
  if p
     then putStrLn "   -> PASS: Element ScaleTransform -> Atomic Number Z & Homomorphism verified (QuickCheck)."
     else do
       putStrLn "   -> FAIL: Chemistry ScaleTransform check failed."
       exitWith (ExitFailure 1)

  putStrLn ""
  putStrLn "--- PART 2: MOLECULAR REACTION KINETICS CONSERVATION (TRANSITION NETWORK) ---"
  if auditMolecularReactionKineticsProof
     then putStrLn "   -> PASS: Molecular reaction kinetics atomic conservation and mass action verified."
     else do
       putStrLn "   -> FAIL: Reaction network verification failed."
       exitWith (ExitFailure 1)

  putStrLn ""
  putStrLn "=========================================================================="
  putStrLn "   ✨ ALL DISCRETE CHEMISTRY SUITES PASSED WITH 100% TOTALITY! ✨"
  putStrLn "=========================================================================="
