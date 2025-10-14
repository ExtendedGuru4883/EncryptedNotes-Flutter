class ChallengeResponse
{
    final String signatureSaltBase64;
    final String nonceBase64;

    ChallengeResponse(this.signatureSaltBase64, this.nonceBase64);

    Map<String, dynamic> toJson() => {
      'signatureSaltBase64': signatureSaltBase64,
      'nonceBase64': nonceBase64
    };

    ChallengeResponse.fromJson(Map<String, dynamic> json)
    : signatureSaltBase64 = json['signatureSaltBase64'] as String,
      nonceBase64 = json['nonceBase64'] as String;
}