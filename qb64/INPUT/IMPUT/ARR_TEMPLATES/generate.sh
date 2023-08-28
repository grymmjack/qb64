#!/usr/bin/env bash
TYPES=(
    BYTE
    UBYTE
    INT
    UINT
    LONG
    ULONG
    INT64
    UINT64
    SNG
    DBL
    FLT
    STR
)
for t in ${TYPES[@]}; do
    cp ARR_TEMPLATE.BAS "ARR_${t}.BAS"
done

# BYTE
gsed -i 's/{Q}/_BYTE/g' ARR_BYTE.BAS
gsed -i 's/{q}/_byte/g' ARR_BYTE.BAS
gsed -i 's/{UT}/BYTE/g' ARR_BYTE.BAS
gsed -i 's/{LT}/byte/g' ARR_BYTE.BAS
gsed -i 's/{SY}/%%/g' ARR_BYTE.BAS

# UBYTE
gsed -i 's/{Q}/_UNSIGNED _BYTE/g' ARR_UBYTE.BAS
gsed -i 's/{q}/_unsigned _byte/g' ARR_UBYTE.BAS
gsed -i 's/{UT}/UBYTE/g' ARR_UBYTE.BAS
gsed -i 's/{LT}/ubyte/g' ARR_UBYTE.BAS
gsed -i 's/{SY}/~%%/g' ARR_UBYTE.BAS

# INT
gsed -i 's/{Q}/INTEGER/g' ARR_INT.BAS
gsed -i 's/{q}/INTEGER/g' ARR_INT.BAS
gsed -i 's/{UT}/INT/g' ARR_INT.BAS
gsed -i 's/{LT}/int/g' ARR_INT.BAS
gsed -i 's/{SY}/~%/g' ARR_INT.BAS

# UINT
gsed -i 's/{Q}/_UNSIGNED INTEGER/g' ARR_UINT.BAS
gsed -i 's/{q}/_unsigned INTEGER/g' ARR_UINT.BAS
gsed -i 's/{UT}/UINT/g' ARR_UINT.BAS
gsed -i 's/{LT}/uint/g' ARR_UINT.BAS
gsed -i 's/{SY}/~%/g' ARR_UINT.BAS

# LONG
gsed -i 's/{Q}/LONG/g' ARR_LONG.BAS
gsed -i 's/{q}/long/g' ARR_LONG.BAS
gsed -i 's/{UT}/LONG/g' ARR_LONG.BAS
gsed -i 's/{LT}/long/g' ARR_LONG.BAS
gsed -i 's/{SY}/&/g' ARR_LONG.BAS

# ULONG
gsed -i 's/{Q}/_UNSIGNED LONG/g' ARR_ULONG.BAS
gsed -i 's/{q}/_unsigned long/g' ARR_ULONG.BAS
gsed -i 's/{UT}/ULONG/g' ARR_ULONG.BAS
gsed -i 's/{LT}/ulong/g' ARR_ULONG.BAS
gsed -i 's/{SY}/~&/g' ARR_ULONG.BAS

# INT64
gsed -i 's/{Q}/_INTEGER64/g' ARR_INT64.BAS
gsed -i 's/{q}/_integer64/g' ARR_INT64.BAS
gsed -i 's/{UT}/INT64/g' ARR_INT64.BAS
gsed -i 's/{LT}/int64/g' ARR_INT64.BAS
gsed -i 's/{SY}/&&/g' ARR_INT64.BAS

# UINT64
gsed -i 's/{Q}/_UNSIGNED _INTEGER64/g' ARR_UINT64.BAS
gsed -i 's/{q}/_unsigned _integer64/g' ARR_UINT64.BAS
gsed -i 's/{UT}/UINT64/g' ARR_UINT64.BAS
gsed -i 's/{LT}/uint64/g' ARR_UINT64.BAS
gsed -i 's/{SY}/~&&/g' ARR_UINT64.BAS

# SNG
gsed -i 's/{Q}/SINGLE/g' ARR_SNG.BAS
gsed -i 's/{q}/single/g' ARR_SNG.BAS
gsed -i 's/{UT}/SNG/g' ARR_SNG.BAS
gsed -i 's/{LT}/sng/g' ARR_SNG.BAS
gsed -i 's/{SY}/!/g' ARR_SNG.BAS

# DBL
gsed -i 's/{Q}/DOUBLE/g' ARR_DBL.BAS
gsed -i 's/{q}/double/g' ARR_DBL.BAS
gsed -i 's/{UT}/DBL/g' ARR_DBL.BAS
gsed -i 's/{LT}/dbl/g' ARR_DBL.BAS
gsed -i 's/{SY}/#/g' ARR_DBL.BAS

# FLT
gsed -i 's/{Q}/_FLOAT/g' ARR_FLT.BAS
gsed -i 's/{q}/_float/g' ARR_FLT.BAS
gsed -i 's/{UT}/FLT/g' ARR_FLT.BAS
gsed -i 's/{LT}/flt/g' ARR_FLT.BAS
gsed -i 's/{SY}/##/g' ARR_FLT.BAS

# STR
gsed -i 's/{Q}/STRING/g' ARR_STR.BAS
gsed -i 's/{q}/string/g' ARR_STR.BAS
gsed -i 's/{UT}/STR/g' ARR_STR.BAS
gsed -i 's/{LT}/str/g' ARR_STR.BAS
gsed -i 's/{SY}/$/g' ARR_STR.BAS
