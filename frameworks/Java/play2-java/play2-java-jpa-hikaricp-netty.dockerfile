FROM hseeberger/scala-sbt:8u242_1.3.8_2.13.1
WORKDIR /play2
COPY play2-java-jpa-hikaricp .

RUN sed -i 's/.enablePlugins(PlayMinimalJava, PlayNettyServer)/.enablePlugins(PlayMinimalJava, PlayNettyServer).disablePlugins(PlayAkkaHttpServer)/g' build.sbt

RUN sbt stage
CMD target/universal/stage/bin/play2-java-jpa-hikaricp -Dplay.server.provider=play.core.server.NettyServerProvider -J-server -J-Xms1g -J-Xmx1g -J-XX:NewSize=512m -J-XX:+UseG1GC -J-XX:MaxGCPauseMillis=30 -J-XX:-UseBiasedLocking -J-XX:+AlwaysPreTouch -Dthread_count=$(nproc) -Dphysical_cpu_count=$(grep ^cpu\\scores /proc/cpuinfo | uniq | awk '{print $4}') -Ddb_pool_size=$(( $(( $(nproc) * 2 )) + 1 ))
