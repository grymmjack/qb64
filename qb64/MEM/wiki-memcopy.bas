'copy array a to array b in memory instantly:
DIM ma AS _MEM: ma = _MEM(a()) 'place array data into blocks
DIM mb AS _MEM: mb = _MEM(b())
_MEMCOPY ma, ma.OFFSET, ma.SIZE TO mb, mb.OFFSET
_MEMFREE ma: _MEMFREE mb 'clear the memory when done
