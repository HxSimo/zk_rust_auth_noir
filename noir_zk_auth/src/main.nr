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
    
    // Safety: This is safe because the scalar is valid and CurveJ::from(P) is well-formed
    let transcript = unsafe { get_transcript(CurveJ::from(P), scalar) };

    let result = P.mul_with_hint(scalar, transcript);

    (result.x, result.y)
}

unconstrained fn get_transcript(P: BN254J, scalar: ScalarField<64>) -> [AffineTranscript<Fq>; 326] {
    let (_, transcript) = P.mul(scalar);
    transcript
}

#[test]
fn test_pubkey_from_scalar() {
    let sk: Field = 12345;
    let (x, y) = main(sk);

    let expected_x = BigNum::<3, 254, BN254_Fq_Params>::from(11404940445424363337823423808411232433223590477377068719858726746225925918890);
    let expected_y = BigNum::<3, 254, BN254_Fq_Params>::from(2424505913866680143139332783087422983475325405994502385033744924144562639386);

    assert(x == expected_x); 
    assert(y == expected_y);
}