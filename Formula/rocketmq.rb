# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Rocketmq < Formula
  desc "Apache RocketMQ is a distributed messaging and streaming platform with low latency, high performance and reliability, trillion-level capacity and flexible scalability."
  homepage "https://rocketmq.apache.org/"
  version "4.6.1"
  url "http://mirror.bit.edu.cn/apache/rocketmq/4.6.0/rocketmq-all-4.6.0-bin-release.zip"
  sha256 "584910d50639297808dd0b86fcdfaf431efd9607009a44c6258d9a0e227748fe"

  bottle :unneeded
  # depends_on "cmake" => :build

  def install
    # Install everything else into package directory
    libexec.install "bin", "conf", "lib"

    inreplace "#{libexec}/conf/logback_namesrv.xml" do |s|
      s.gsub!(/\$\{user\.home\}/, "#{var}/log/rocketmq")
    end

    inreplace "#{libexec}/conf/logback_broker.xml" do |s|
      s.gsub!(/\$\{user\.home\}/, "#{var}/log/rocketmq")
    end

    # Move config files into etc
    (libexec/"conf/broker.conf").rmtree
    (libexec/"conf/broker.conf").write broker_conf
    (etc/"rocketmq").install Dir[libexec/"conf/*"]
    (libexec/"conf").rmtree

    Dir.foreach(libexec/"bin") do |f|
      next if f == "." || f == ".." || !File.extname(f).empty?

      bin.install libexec/"bin"/f
    end
    bin.env_script_all_files(libexec/"bin", {})
  end

  def post_install
    (var/"rocketmq").mkpath
    (var/"log/rocketmq").mkpath
    (var/"rocketmq/commitlog").mkpath
    ln_s etc/"rocketmq", libexec/"conf"
  end

  def broker_conf; <<~EOS
      brokerClusterName = DefaultCluster
      brokerName = broker-a
      brokerId = 0
      deleteWhen = 04
      fileReservedTime = 48
      brokerRole = ASYNC_MASTER
      flushDiskType = ASYNC_FLUSH
      storePathRootDir=#{var}/rocketmq
      storePathCommitLog=#{var}/rocketmq/commitlog
      autoCreateTopicEnable=true
  EOS
  end


  def caveats
    s = <<~EOS
      Data:    #{var}/rocketmq/commitlog
      Logs:    #{var}/log/rocketmq/
      Config:  #{etc}/rocketmq/broker.conf
    EOS

    s
  end

  plist_options :manual => "mqbroker -n localhost:9876 -c  #{HOMEBREW_PREFIX}/etc/rocketmq/broker.conf autoCreateTopicEnable=true"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/mqbroker</string>
        <string>-n</string>
        <string>localhost:9876</string>
        <string>-c</string>
        <string>#{etc}/rocketmq/broker.conf</string>
        <string>autoCreateTopicEnable=true</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/rocketmq/output.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/rocketmq/output.log</string>
    </dict>
    </plist>
  EOS
  end



  test do
    system "#{bin}/mqadmin"
  end
end
