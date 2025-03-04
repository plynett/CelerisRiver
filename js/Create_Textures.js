// Create_Textures.js
export function create_2D_Texture(device, width, height, allTextures) {
    const texture = device.createTexture({
        size: [width, height, 1],
        format: 'rgba32float',
        usage: GPUTextureUsage.STORAGE_BINDING | GPUTextureUsage.COPY_SRC | GPUTextureUsage.COPY_DST | GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.TEXTURE_BINDING
    });
    
    // Add the created texture to the tracking set
    allTextures.add(texture);

    return texture;
}

export function create_2D_Image_Texture(device, width, height, allTextures) {
    const texture = device.createTexture({
        size: [width, height, 1],
        format: 'bgra8unorm',
        usage: GPUTextureUsage.COPY_SRC | GPUTextureUsage.COPY_DST | GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.TEXTURE_BINDING
    });
    
    // Add the created texture to the tracking set
    allTextures.add(texture);

    return texture;
}

export function create_3D_Image_Texture(device, width, height, depth, allTextures) {
    const texture = device.createTexture({
        size: [width, height, depth],
        format: 'bgra8unorm',
        usage: GPUTextureUsage.COPY_SRC | GPUTextureUsage.COPY_DST | GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.TEXTURE_BINDING
    });
    
    // Add the created texture to the tracking set
    allTextures.add(texture);

    return texture;
};
   

export function create_1D_Texture(device, width, allTextures) {
    const texture = device.createTexture({
        size: [width, 1, 1],
        format: 'rgba32float',
        usage: GPUTextureUsage.STORAGE_BINDING | GPUTextureUsage.COPY_SRC | GPUTextureUsage.COPY_DST | GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.TEXTURE_BINDING
    });
    
    // Add the created texture to the tracking set
    allTextures.add(texture);

    return texture;
}

export function createUniformBuffer(device) {
    return device.createBuffer({
        size: 256,  // smallest multiple of 256
        usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC
    });
}

