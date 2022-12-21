local module = {}

module.Serializers = {}

function module:CreateSerializer(title: string, serializer, deserializer)
    module.Serializers[title] = {Serializer = serializer, Deserializer = deserializer}
end

return module