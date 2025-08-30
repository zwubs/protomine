import datamine/common
import datamine/common/block
import datamine/common/block/block_property
import gleam/int
import gleam/list
import gleam/string
import justin
import simplifile

const block_type_filepath = "./src/protocol/block/block_type.gleam"

const block_state_filepath = "./src/protocol/block/block_state.gleam"

pub fn generate(version: common.Version) {
  let blocks = version.blocks
  let _ = simplifile.create_file(block_type_filepath)
  let assert Ok(_) =
    simplifile.write(block_type_filepath, build_block_type_type(blocks))
  let _ = simplifile.create_file(block_state_filepath)
  let block_state_file_content =
    [
      build_block_state_type(blocks),
      build_block_state_to_int(blocks),
    ]
    |> string.join("\n\n")
  let assert Ok(_) =
    simplifile.write(block_state_filepath, block_state_file_content)
}

fn identifier_to_variant_name(identifier: String) {
  identifier
  |> string.drop_start(10)
  |> justin.pascal_case()
}

fn property_name_to_record_field(name: String) {
  case name {
    "type" -> "type_"
    name -> name
  }
}

fn build_block_type_type(blocks: List(block.Block)) {
  list.map(blocks, fn(block) {
    identifier_to_variant_name(block.identifier)
    |> string.append("  ", _)
    |> string.append("\n")
  })
  |> string.join("")
  |> string.append("pub type BlockType {\n  ", _)
  |> string.append("\n}")
}

fn build_block_state_type(blocks: List(block.Block)) {
  list.map(blocks, fn(block) {
    let variant = identifier_to_variant_name(block.identifier)
    let fields = case block.properties {
      [] -> ""
      properties ->
        [
          "(",
          list.map(properties, fn(property) {
            property_name_to_record_field(property.name)
            <> ": "
            |> string.append(case property {
              block_property.Bool(..) -> "Bool"
              block_property.Int(..) -> "Int"
              block_property.Enum(..) -> "String"
            })
          })
            |> string.join(", "),
          ")",
        ]
        |> string.join("")
    }
    variant
    |> string.append(fields)
  })
  |> string.join("\n  ")
  |> string.append("pub type BlockState {\n  ", _)
  |> string.append("\n}")
}

fn build_block_state_to_int(blocks: List(block.Block)) {
  [
    "pub fn to_int(block_state: BlockState) {",
    "  case block_state {",
    list.flat_map(blocks, fn(block) {
      let variant = identifier_to_variant_name(block.identifier)
      let values = block_property_permutations([], block.properties)
      case values {
        [] -> [variant]
        _ -> list.map(values, fn(value) { variant <> "(" <> value <> ")" })
      }
    })
      |> list.index_map(fn(match, index) {
        match <> " -> " <> int.to_string(index)
      })
      |> string.join("\n    ")
      |> string.append("    ", _),
    "    _ -> 0",
    "  }",
    "}",
  ]
  |> string.join("\n")
}

fn block_property_permutations(
  permutations: List(String),
  properties: List(block_property.BlockProperty),
) -> List(String) {
  case properties {
    [] -> permutations
    [property, ..properties] -> {
      let values = case property {
        block_property.Bool(..) -> ["True", "False"]
        block_property.Int(_, min:, max:) ->
          list.range(min, max) |> list.map(int.to_string)
        block_property.Enum(_, values:) ->
          values |> list.map(fn(value) { "\"" <> value <> "\"" })
      }
      case permutations {
        [] -> block_property_permutations(values, properties)
        _ -> {
          list.flat_map(permutations, fn(permutation) {
            list.map(values, fn(value) { permutation <> ", " <> value })
            |> block_property_permutations(properties)
          })
        }
      }
    }
  }
}
