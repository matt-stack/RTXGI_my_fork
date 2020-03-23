/*
* Copyright (c) 2019-2020, NVIDIA CORPORATION.  All rights reserved.
*
* NVIDIA CORPORATION and its licensors retain all intellectual property
* and proprietary rights in and to this software, related documentation
* and any modifications thereto.  Any use, reproduction, disclosure or
* distribution of this software and related documentation without an express
* license agreement from NVIDIA CORPORATION is strictly prohibited.
*/

#include "../../../rtxgi-sdk/shaders/ddgi/ProbeCommon.hlsl"

#include "include/RTGlobalRS.hlsl"

[numthreads(1, 1, 1)]
void VisUpdateTLASCS(uint3 DispatchThreadID : SV_DispatchThreadID, uint GroupIndex : SV_GroupIndex)
{
#if RTXGI_DDGI_PROBE_RELOCATION
    float3 probeWorldPosition = DDGIGetProbeWorldPositionWithOffset(DispatchThreadID.x, DDGIVolume.origin, DDGIVolume.probeGridCounts, DDGIVolume.probeGridSpacing, DDGIProbeOffsets);
#else
    float3 probeWorldPosition = DDGIGetProbeWorldPosition(DispatchThreadID.x, DDGIVolume.origin, DDGIVolume.probeGridCounts, DDGIVolume.probeGridSpacing);
#endif

    VisTLASInstances[DispatchThreadID.x].transform = float3x4(
        VizProbeRadius, probeWorldPosition.x, 0.0f, 0.f,
        0.0f, 0.0f, probeWorldPosition.y, VizProbeRadius,
        0.0f, VizProbeRadius, 0.f, probeWorldPosition.z);

    VisTLASInstances[DispatchThreadID.x].instanceID24_Mask8 = 0xFF000000;
    VisTLASInstances[DispatchThreadID.x].GPUAddress = BLASGPUAddress;
}
