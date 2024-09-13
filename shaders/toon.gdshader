shader_type spatial;

#define USE_RIM 1

#define USE_PIXELART 1
#define USE_SMOOTH_PIXELART 1

#define USE_ALPHA 1
#define USE_DISABLE_CULL 1

#define USE_SUBSURFACESCATTERING 1

render_mode
	#if USE_DISABLE_CULL
		cull_disabled;
	#else
		cull_back;
	#endif

group_uniforms Toon;
uniform float     ToonRampOffset:     hint_range(0.0, 1.0) = 0.5;
uniform float     ToonRampSmoothness: hint_range(0.0, 1.0) = 0.05;
uniform vec3      ToonRampTinting:    source_color;

#if USE_RIM
	group_uniforms Rim;
	uniform float     RimPower:           hint_range(0.0, 10.0) = 1.0;
	uniform float     RimCutOff:          hint_range(0.0, 1.0) = 0.5;
	uniform float     RimSmoothness:      hint_range(0.0, 1.0) = 0.05;
	uniform float     RimLightBrightness: hint_range(0.0, 50.0) = 20.0;
#endif

#if USE_SUBSURFACESCATTERING
	group_uniforms SubsurfaceScattering;
	uniform float     SubSurfDistortion:  hint_range(0.0, 5.0) = 1.0;
	uniform vec3      SubSurfTint:        source_color;
	uniform float     SubSurfBrightness:  hint_range(0.0, 10.0) = 3.0;
	uniform float     SubSurfCutoff:      hint_range(0.0, 1.0) = 0.5;
	uniform float     SubSurfSmoothness:  hint_range(0.0, 1.0) = 0.05;
	uniform sampler2D SubSurfTexture:  source_color, hint_default_white;

#endif

group_uniforms Texture;
#if (USE_SMOOTH_PIXELART || !USE_PIXELART)
	uniform sampler2D Texture:            source_color, filter_linear_mipmap_anisotropic;
#else
	uniform sampler2D Texture:            source_color, filter_nearest_mipmap_anisotropic;
#endif

#if USE_RIM
	float fresnel(float amount, vec3 normal, vec3 view) {
		return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
	}
#endif

#if USE_SMOOTH_PIXELART
	vec4 texture_point_smooth(sampler2D smp, vec2 uv, vec2 pixel_size) {
		vec2 ddx = dFdx(uv);
		vec2 ddy = dFdy(uv);
		vec2 lxy = sqrt(ddx * ddx + ddy * ddy);

		vec2 uv_pixels = uv / pixel_size;

		vec2 uv_pixels_floor = round(uv_pixels) - vec2(0.5f);
		vec2 uv_dxy_pixels = uv_pixels - uv_pixels_floor;

		uv_dxy_pixels = clamp((uv_dxy_pixels - vec2(0.5f)) * pixel_size / lxy + vec2(0.5f), 0.0f, 1.0f);

		uv = uv_pixels_floor * pixel_size;

		return textureGrad(smp, uv + uv_dxy_pixels * pixel_size, ddx, ddy);
	}
#endif

void fragment() {
	vec4 textureColor;

	#if USE_SMOOTH_PIXELART
		vec2 tex_size = 1.0f / vec2(textureSize(Texture, 0));
		textureColor = texture_point_smooth(Texture, UV, tex_size);
	#else
		textureColor = texture(Texture, UV);
	#endif
		ALBEDO = textureColor.rgb;

	#if USE_ALPHA
		ALPHA = textureColor.a;
		ALPHA_SCISSOR_THRESHOLD = 0.5;
	#endif
}

void light() {
	// Diffuse Shading
	float d =  dot(NORMAL,LIGHT) * 0.5 + 0.5;
	float toonRamp = smoothstep(ToonRampOffset, ToonRampOffset + ToonRampSmoothness, d);

	// Shadows
	toonRamp *= ATTENUATION;

	vec3 toonRampOutput = LIGHT_COLOR * toonRamp;
	vec3 ambientLightOutput = ALBEDO * ToonRampTinting;
	DIFFUSE_LIGHT += clamp((toonRampOutput - ambientLightOutput), vec3(0.0), vec3(1.0));


	#if USE_RIM
		float fresnel = fresnel(RimPower, NORMAL, VIEW);
		float d2 = dot(NORMAL, LIGHT);
		d2 *= fresnel;
		d2 = smoothstep(RimCutOff, RimCutOff + RimSmoothness, d2);

		vec3 rimOutput =  d2 * RimLightBrightness * ALBEDO;

		DIFFUSE_LIGHT += rimOutput;
	#endif



	#if USE_SUBSURFACESCATTERING
		float subSurfBack = dot(VIEW, -(LIGHT + NORMAL * SubSurfDistortion));
		float subSurfFront = dot(VIEW, LIGHT - NORMAL * SubSurfDistortion);
		subSurfBack = max(subSurfBack, 0.0);
		subSurfFront = max(subSurfFront, 0.0);

		float subSurfScattering = smoothstep(SubSurfCutoff, SubSurfCutoff + SubSurfSmoothness, subSurfBack + subSurfFront);

		vec3 subSurfColor = SubSurfTint * texture(SubSurfTexture, UV).rgb;
		DIFFUSE_LIGHT += subSurfScattering * SubSurfBrightness * subSurfColor;
	#endif


	SPECULAR_LIGHT = ambientLightOutput;
}