use ark_bn254::{Fr, G1Projective};
use ark_ec::{CurveGroup, PrimeGroup};
use std::str::FromStr;
use std::ops::Mul;

fn main() {
    let sk = Fr::from_str("12345").unwrap();
    let g = G1Projective::generator();    // generate G
    let pubkey = g.mul(sk);     // Scalar mul : G * sk
    let affine = pubkey.into_affine();

    println!("x = {}", affine.x);
    println!("y = {}", affine.y);
}
