import datamine/common/protocol/data_type
import datamine/common/protocol/phase_id
import gleam/result
import protocol/decoder

pub type Packet {
  Intention(
    protocol_version: Int,
    server_host: String,
    server_port: Int,
    next_state: Int,
  )
  StatusRequest
  PingRequest(timestamp: Int)
}

pub fn get_schema(phase_id: phase_id.PhaseId, id: Int) {
  case phase_id {
    phase_id.Handshake -> {
      case id {
        0 -> intention_schema
        _ -> todo
      }
    }
    phase_id.Status -> {
      case id {
        0 -> []
        1 -> ping_request_schema
        _ -> todo
      }
    }
    _ -> todo
  }
}

const intention_schema = [
  data_type.VarInt,
  data_type.String(255),
  data_type.UnsignedShort,
  data_type.VarInt,
]

pub fn decode_intention(bit_array: BitArray) {
  use #(protocol_version, bit_array) <- result.try(decoder.var_int(bit_array))
  use #(server_host, bit_array) <- result.try(decoder.string(bit_array))
  use #(server_port, bit_array) <- result.try(decoder.unsigned_short(bit_array))
  use #(next_state, _bit_array) <- result.try(decoder.var_int(bit_array))
  Ok(Intention(protocol_version, server_host, server_port, next_state))
}

const ping_request_schema = [data_type.Long]
