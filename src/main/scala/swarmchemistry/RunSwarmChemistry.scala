package swarmchemistry

import swarmchemistry.SwarmChemistry.Space

import scala.util.Random

object RunSwarmChemistry extends App {

  System.setProperty("java.util.Arrays.useLegacyMergeSort", "true")

  //private val seed: Long = new Random(42).nextLong()
  private val seed: Long = new Random().nextLong()

  implicit val rng: Random = Random(seed)
  implicit val model: SwarmChemistry = SwarmChemistry()

  //SwarmChemistry.runSwarmChemistry("random:10", "uniform")
  //println(SwarmChemistry.indicators)

  val gens = Seq("random", "uniform", "split", "zipf")
  //val gens = Seq("split")
  for (spatialGenerator <- gens) {
    Space.initialiseSpace(spatialGenerator)
    //println(SwarmChemistry.spatialCompetition.map(_.toSeq).toSeq)
    //println(SwarmChemistry.spatialCompetition.head.head)
    Space.exportSpaceImage("results/setup/space-"+spatialGenerator+"-seed"+seed.toString+".png")
  }

}
