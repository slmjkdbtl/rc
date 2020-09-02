" Vim syntax file
" Language:     ShaderLab
" Maintainer:   mingchaoyan <mingchaoyan@gmail.com>
"

if exists("b:current_syntax")
  finish
endif

syntax keyword shaderlabKeyword Shader
syntax keyword shaderlabKeyword Category
syntax keyword shaderlabKeyword Properties
syntax keyword shaderlabKeyword SubShader
syntax keyword shaderlabKeyword Pass
syntax keyword shaderlabKeyword Tags
syntax keyword shaderlabKeyword LOD
syntax keyword shaderlabKeyword Fallback
syntax keyword shaderlabKeyword Material
syntax keyword shaderlabKeyword Lighting
syntax keyword shaderlabKeyword Cull
syntax keyword shaderlabKeyword ZTest
syntax keyword shaderlabKeyword ZWrite
syntax keyword shaderlabKeyword Fog
syntax keyword shaderlabKeyword AlphaTest
syntax keyword shaderlabKeyword BindChannels
syntax keyword shaderlabKeyword Blend
syntax keyword shaderlabKeyword ColorMask
syntax keyword shaderlabKeyword Offset
syntax keyword shaderlabKeyword SeparateSpecular
syntax keyword shaderlabKeyword ColorMaterial
syntax keyword shaderlabKeyword UsePass

syntax keyword shaderlabProperty Int
syntax keyword shaderlabProperty Float
syntax keyword shaderlabProperty Range
syntax keyword shaderlabProperty Vector
syntax keyword shaderlabProperty Color
syntax keyword shaderlabProperty 2D
syntax keyword shaderlabProperty 3D
syntax keyword shaderlabProperty Cube

syntax keyword shaderlabType fixed
syntax keyword shaderlabType fixed2
syntax keyword shaderlabType fixed3
syntax keyword shaderlabType fixed4
syntax keyword shaderlabType half
syntax keyword shaderlabType half2
syntax keyword shaderlabType half3
syntax keyword shaderlabType half4
syntax keyword shaderlabType float
syntax keyword shaderlabType float2
syntax keyword shaderlabType float3
syntax keyword shaderlabType float4
syntax keyword shaderlabType SurfaceOutput
syntax keyword shaderlabType bool
syntax keyword shaderlabType samplerCUBE
syntax keyword shaderlabType sampler2D
syntax keyword shaderlabType sampler3D
syntax keyword shaderlabType void
syntax keyword shaderlabType 2D
syntax keyword shaderlabType struct

syntax keyword shaderlabSemantics POSITION
syntax keyword shaderlabSemantics NORMAL
syntax keyword shaderlabSemantics TANGENG
syntax match shaderlabSemantics 'TEXCOORD\d'
syntax keyword shaderlabSemantics COLOR
syntax keyword shaderlabSemantics SV_POSITION
syntax keyword shaderlabSemantics COLOR1
syntax keyword shaderlabSemantics COLOR2
syntax keyword shaderlabSemantics SV_Target

syntax keyword shaderlabFunction length
syntax keyword shaderlabFunction cross
syntax keyword shaderlabFunction pow
syntax keyword shaderlabFunction tex2D
syntax keyword shaderlabFunction UnpackNormal
syntax keyword shaderlabFunction saturate
syntax keyword shaderlabFunction dot
syntax keyword shaderlabFunction normalize
syntax keyword shaderlabFunction clip
syntax keyword shaderlabFunction frac
syntax keyword shaderlabFunction mul
syntax keyword shaderlabFunction TRANSFORM_TEX
syntax keyword shaderlabFunction SetTexture
syntax keyword shaderlabFunction combine
syntax keyword shaderlabFunction UnityPixelSnap

syntax keyword shaderlabStatement return

syntax keyword shaderlabCGProgram CGPROGRAM
syntax keyword shaderlabCGProgram ENDCG

syntax region shaderlabString start=/\v"/ skip=/\v\\./ end=/\v"/

syntax match shaderlabNumber '\<\d\+\>'
syntax match shaderlabFloat '\<\d\+\.\d\+\>'

syntax match shaderlabOperator "\v\="
syntax match shaderlabOperator "\v\*"
syntax match shaderlabOperator "\v/"
syntax match shaderlabOperator "\v\+"
syntax match shaderlabOperator "\v-"
syntax match shaderlabOperator "\v\?"
syntax match shaderlabOperator "\v\*\="
syntax match shaderlabOperator "\v/\="
syntax match shaderlabOperator "\v\+\="
syntax match shaderlabOperator "\v-\="

syntax match shaderlabComment '\v\/\/.*$'

syn region      shaderlabPreProc        start="^\s*\(%:\|#\)\s*\(pragma\>\|include\>\)" skip="\\$" end="$" keepend contains=ALLBUT

highlight link shaderlabKeyword    Keyword
highlight link shaderlabProperty   StorageClass
highlight link shaderlabType       Type
highlight link shaderlabSemantics  Typedef

highlight link shaderlabString     String
highlight link shaderlabNumber     Number
highlight link shaderlabFloat      Float
highlight link shaderlabOperator   Operator

highlight link shaderlabFunction   Function
highlight link shaderlabStatement  Statement
highlight link shaderlabCGProgram  PreCondit
highlight link shaderlabComment    Comment
highlight link shaderlabPreProc    PreCondit


let b:current_syntax = "shaderlab"
