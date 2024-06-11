scalaVersion := "3.2.2"

name := "swarmchemistryspatialsensitivity"

version := "0.1-SNAPSHOT"

// model as openmole plugin
enablePlugins(SbtOsgi)
OsgiKeys.exportPackage := Seq("swarmchemistry.*")
OsgiKeys.importPackage := Seq("*;resolution:=optional")
OsgiKeys.privatePackage := Seq("!scala.*,*")
OsgiKeys.requireCapability := """osgi.ee;filter:="(&(osgi.ee=JavaSE)(version=1.8))""""

resolvers += "Sonatype OSS Snapshots" at "https://oss.sonatype.org/content/repositories/snapshots"
resolvers += "Sonatype OSS Releases" at "https://oss.sonatype.org/content/repositories/releases"
resolvers += "Sonatype OSS Staging" at "https://oss.sonatype.org/content/repositories/staging"


libraryDependencies ++= Seq(
  "org.apache.commons" % "commons-math3" % "3.6.1"
)
