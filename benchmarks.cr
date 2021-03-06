require "benchmark"

CRCs = {
  "crc1"          => "CRC1",
  "crc5"          => "CRC5",
  "crc8"          => "CRC8",
  "crc8_1wire"    => "CRC81Wire",
  "crc15"         => "CRC15",
  "crc16"         => "CRC16",
  "crc16_ccitt"   => "CRC16CCITT",
  "crc16_dnp"     => "CRC16DNP",
  "crc16_genibus" => "CRC16Genibus",
  "crc16_modbus"  => "CRC16Modbus",
  "crc16_qt"      => "CRC16QT",
  "crc16_usb"     => "CRC16USB",
  "crc16_x_25"    => "CRC16X25",
  "crc16_xmodem"  => "CRC16XModem",
  "crc16_zmodem"  => "CRC16ZModem",
  "crc24"         => "CRC24",
  "crc32"         => "CRC32",
  "crc32_bzip2"   => "CRC32BZip2",
  "crc32c"        => "CRC32c",
  "crc32_jam"     => "CRC32Jam",
  "crc32_mpeg"    => "CRC32Mpeg",
  "crc32_posix"   => "CRC32POSIX",
  "crc32_xfer"    => "CRC32XFER",
  "crc64"         => "CRC64",
  "crc64_jones"   => "CRC64Jones",
  "crc64_xz"      => "CRC64XZ",
}

{% for file in CRCs.keys %}
require "./src/crc/{{ file.id }}"
{% end %}

N = 1000
BLOCK_SIZE = 8 * 1024

puts "Generating #{N} #{BLOCK_SIZE / 1024}Kb lengthed strings ..."
SAMPLES = Array.new(N) do
  Array.new(BLOCK_SIZE) { rand(256).chr }.join
end

puts "Benchmarking CRC::CRC classes ..."
Benchmark.bm do |b|
  {% for file, constant in CRCs %}
    {% begin %}
      {{ file.id }} = CRC::{{ constant.id }}.new

      b.report("CRC::{{ constant.id }}#update") do
        SAMPLES.each do |sample|
          {{ file.id }}.update(sample)
        end
      end
    {% end %}
  {% end %}
end
