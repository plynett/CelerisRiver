struct Globals {
    width: u32,
    height: u32,
    dx: f32,
    dy: f32,
    Bcoef: f32
};

@group(0) @binding(0) var<uniform> globals: Globals;

@group(0) @binding(1) var txBottom: texture_2d<f32>;
@group(0) @binding(2) var current_state: texture_2d<f32>;

@group(0) @binding(3) var coefMatx: texture_storage_2d<rgba32float, write>;
@group(0) @binding(4) var coefMaty: texture_storage_2d<rgba32float, write>;

@compute @workgroup_size(16, 16)
fn main(@builtin(global_invocation_id) id: vec3<u32>) {
    let idx = vec2<i32>(i32(id.x), i32(id.y));

    let width = i32(globals.width);
    let height = i32(globals.height);

    let leftIdx = idx + vec2<i32>(-1, 0);
    let rightIdx = idx + vec2<i32>(1, 0);
    let downIdx = idx + vec2<i32>(0, -1);
    let upIdx = idx + vec2<i32>(0, 1);

    let d_here = -textureLoad(txBottom, idx, 0).z;
    let near_dry = d_here; //textureLoad(txBottom, idx, 0).w;

    var a = 0.0;
    var b = 1.0;
    var c = 0.0;

    // X-coefs
    var coefx = vec4<f32>(0.0, 0.0, 0.0, 0.0);
    if (idx.x <= 2 || idx.x >= width - 3 || near_dry < 0.0) {
        a = 0.0;
        b = 1.0;
        c = 0.0;
    }
    else {

        let d_west = -textureLoad(txBottom, leftIdx, 0).z;
        let d_east = -textureLoad(txBottom, rightIdx, 0).z;

         // Calculate the first derivative of the depth
         let d_dx = (d_east - d_west) / (2.0 * globals.dx);

         // Calculate coefficients based on the depth and its derivative
         a =  d_here * d_dx / (6.0 * globals.dx) - (globals.Bcoef + 1.0 / 3.0) * d_here * d_here / (globals.dx * globals.dx);
         b = 1.0 + 2.0 * (globals.Bcoef + 1.0 / 3.0) * d_here * d_here / (globals.dx * globals.dx);
         c = -d_here * d_dx / (6.0 * globals.dx) - (globals.Bcoef + 1.0 / 3.0) * d_here * d_here / (globals.dx * globals.dx);
    }
    coefx = vec4<f32>(a, b, c, 0.0);

    // Y-coefs
    var coefy = vec4<f32>(0.0, 0.0, 0.0, 0.0);
    if (idx.y <= 2 || idx.y >= height - 3 || near_dry < 0.0) {
        a = 0.0;
        b = 1.0;
        c = 0.0;
    }
    else {

        let d_south = -textureLoad(txBottom, downIdx, 0).z;
        let d_north = -textureLoad(txBottom, upIdx, 0).z;

         // Calculate the first derivative of the depth
         let d_dy = (d_north - d_south) / (2.0 * globals.dy);

         // Calculate coefficients based on the depth and its derivative
         a =  d_here * d_dy / (6.0 * globals.dy) - (globals.Bcoef + 1.0 / 3.0) * d_here * d_here / (globals.dy * globals.dy);
         b = 1.0 + 2.0 * (globals.Bcoef + 1.0 / 3.0) * d_here * d_here / (globals.dy * globals.dy);
         c = -d_here * d_dy / (6.0 * globals.dy) - (globals.Bcoef + 1.0 / 3.0) * d_here * d_here / (globals.dy * globals.dy);
    }
    coefy = vec4<f32>(a, b, c, 0.0);

    textureStore(coefMatx, idx, coefx);
    textureStore(coefMaty, idx, coefy);
}

