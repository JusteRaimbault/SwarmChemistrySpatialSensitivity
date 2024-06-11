package swarmchemistry

import scala.util.Random

object RunSwarmChemistry extends App {

  System.setProperty("java.util.Arrays.useLegacyMergeSort", "true")

  implicit val rng: Random = Random
  implicit val model: SwarmChemistry = SwarmChemistry()

  SwarmChemistry.runSwarmChemistry("random:10", "uniform")

  println(SwarmChemistry.indicators)

}
