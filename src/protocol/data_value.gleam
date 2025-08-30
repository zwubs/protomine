import nbeet

pub type DataValue {
  Boolean(Bool)
  Byte(Int)
  UnsignedByte(Int)
  Short(Int)
  UnsignedShort(Int)
  Int(Int)
  Long(Int)
  Float(Float)
  Double(Float)
  String(String)
  TextComponent
  JSONTextComponent
  Identifier
  VarInt(Int)
  VarLong(Int)
  EntityMetadata
  Slot
  NBT(nbeet.Nbt)
  Position
  Angle
  UUID
  BitSet(List(Int))
  FixedBitSet(List(Int))
  Optional(DataValue)
  PrefixedOptional(DataValue)
  Array(DataValue)
  PrefixedArray(DataValue)
  Enum(DataValue)
  ByteArray(BitArray)
  Id
  IdSet
  SoundEvent
  TeleportFlags
  RecipeDisplay
  SlotDisplay
  ChunkData
  LightData
  Record(List(Field))
}

pub type Field {
  Field(name: String, data_value: DataValue)
}
