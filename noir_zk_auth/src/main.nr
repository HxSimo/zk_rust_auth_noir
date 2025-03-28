use noir_bigcurve::scalar_field::ScalarField;
use noir_bigcurve::curves::bn254::{BN254, BN254Params};
use noir_bigcurve::BigCurve::one;
use noir_bigcurve::curve_jac::{CurveJ, AffineTranscript};

use bignum::{fields::bn254Fq::BN254_Fq_Params, BigNum};

type Fq = BigNum<3, 254, BN254_Fq_Params>;

type BN254J = CurveJ<Fq, BN254Params>;

fn main(sk: Field) -> pub (BigNum<3, 254, BN254_Fq_Params>, BigNum<3, 254, BN254_Fq_Params>) {
    let P: BN254 = one();
    let scalar: ScalarField<64> = ScalarField::from(sk);

    let transcript = unsafe { get_transcript(CurveJ::from(P), scalar) };

    let result = P.mul_with_hint(scalar, transcript);

    (result.x, result.y)
}

unconstrained fn get_transcript(P: BN254J, scalar: ScalarField<64>) -> [AffineTranscript<Fq>; 326] {
    let (_, transcript) = P.mul(scalar);
    transcript
}