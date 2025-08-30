import datamine/common/protocol/data_type
import protocol/error

pub type DecodeResult(value) =
  Result(#(value, BitArray), error.ProtocolError)

pub fn decode_packet(bit_array: BitArray, schema: List(data_type.DataType)) {
  todo
}

pub fn var_int(_: BitArray) -> DecodeResult(Int) {
  todo as "Implement VarInt decoder"
}

pub fn string(_: BitArray) -> DecodeResult(String) {
  todo as "Implement String decoder"
}

pub fn unsigned_short(_: BitArray) -> DecodeResult(Int) {
  todo as "Implement UnsignedShort decoder"
}
