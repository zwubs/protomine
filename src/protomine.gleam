import argv
import datamine
import datamine/common
import datamine/common/version_number
import datamine/version/v1_21_1
import glam/doc.{type Document}
import gleam/dict
import gleam/io
import gleam/list
import justin
import protocol/block/block_state
import protomine/blocks
import protomine/internal/error

pub fn main() {
  let versions_by_version_number =
    dict.from_list(
      list.map(datamine.versions, fn(version) {
        #(version_number.to_string(version.version_number), version)
      }),
    )
  echo block_state.to_int(block_state.AcaciaButton("wall", "east", False))
  // blocks.generate(v1_21_1.version)
  // case handle_cli(versions_by_version_number) {
  //   Ok(_) -> exit(1)
  //   Error(error) -> {
  //     io.println_error(error.to_string(error))
  //     exit(2)
  //   }
  // }
}

fn handle_cli(versions_by_version_number: dict.Dict(String, common.Version)) {
  case argv.load().arguments {
    ["generate", version] -> {
      case version_number.from_string(version) {
        Ok(version_number) -> {
          case
            dict.get(
              versions_by_version_number,
              version_number.to_string(version_number),
            )
          {
            Ok(version) -> {
              list.each(version.protocol.phases, fn(phase) {
                let packet_type_variants =
                  list.map(phase.clientbound_packets, fn(packet) {
                    doc.from_string(justin.pascal_case(packet.id))
                  })
                doc.from_string("pub type Packet ")
                |> doc.append(
                  list.intersperse(packet_type_variants, doc.line) |> block,
                )
                |> doc.to_string(80)
                |> io.println
              })
              Ok(Nil)
            }
            Error(_) -> Error(error.UnknownVersionNumber(version_number))
          }
        }
        Error(_) -> Error(error.InvalidVersionNumber(version))
      }
    }
    [argument, ..] -> Error(error.UnknownArgument(argument))
    [] -> Ok(Nil)
  }
}

const indent = 2

fn block(body: List(Document)) -> Document {
  [
    doc.from_string("{"),
    [doc.line, ..body]
      |> doc.concat
      |> doc.nest(by: indent),
    doc.line,
    doc.from_string("}"),
  ]
  |> doc.concat
}

@external(erlang, "erlang", "halt")
fn exit(exit_type: Int) -> Nil
