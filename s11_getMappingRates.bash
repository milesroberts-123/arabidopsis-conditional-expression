grep "Mapping rate" *_mapped/logs/salmon_quant.log | sed 's/_.*= / /g' | sed 's/%$//g' > salmonMappingRates.txt