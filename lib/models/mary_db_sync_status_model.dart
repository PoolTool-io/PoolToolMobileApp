class MaryDbSyncStatus {
  num? actualRewardsCompleteEpoch;
  num? blockNo;
  num? delegation;
  String? deletedBlock;
  num? epochNo;
  num? epochParams;
  num? forecastRewardsCompleteEpoch;
  num? maTxMint;
  num? maTxOut;
  num? newRewardsCompleteEpoch;
  num? poolActualsCalculatedEpoch;
  num? poolForecastCalculatedEpoch;
  num? poolRetire;
  num? poolUpdate;
  num? portfolios;
  num? reserve;
  num? reward;
  num? stakeDeregistration;
  num? test;
  num? treasury;
  num? txIn;
  num? txOut;
  num? waitstakeCompleteEpoch;
  num? withdrawal;

//<editor-fold desc="Data Methods">

  MaryDbSyncStatus({
    this.actualRewardsCompleteEpoch,
    this.blockNo,
    this.delegation,
    this.deletedBlock,
    this.epochNo,
    this.epochParams,
    this.forecastRewardsCompleteEpoch,
    this.maTxMint,
    this.maTxOut,
    this.newRewardsCompleteEpoch,
    this.poolActualsCalculatedEpoch,
    this.poolForecastCalculatedEpoch,
    this.poolRetire,
    this.poolUpdate,
    this.portfolios,
    this.reserve,
    this.reward,
    this.stakeDeregistration,
    this.test,
    this.treasury,
    this.txIn,
    this.txOut,
    this.waitstakeCompleteEpoch,
    this.withdrawal,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaryDbSyncStatus &&
          runtimeType == other.runtimeType &&
          actualRewardsCompleteEpoch == other.actualRewardsCompleteEpoch &&
          blockNo == other.blockNo &&
          delegation == other.delegation &&
          deletedBlock == other.deletedBlock &&
          epochNo == other.epochNo &&
          epochParams == other.epochParams &&
          forecastRewardsCompleteEpoch == other.forecastRewardsCompleteEpoch &&
          maTxMint == other.maTxMint &&
          maTxOut == other.maTxOut &&
          newRewardsCompleteEpoch == other.newRewardsCompleteEpoch &&
          poolActualsCalculatedEpoch == other.poolActualsCalculatedEpoch &&
          poolForecastCalculatedEpoch == other.poolForecastCalculatedEpoch &&
          poolRetire == other.poolRetire &&
          poolUpdate == other.poolUpdate &&
          portfolios == other.portfolios &&
          reserve == other.reserve &&
          reward == other.reward &&
          stakeDeregistration == other.stakeDeregistration &&
          test == other.test &&
          treasury == other.treasury &&
          txIn == other.txIn &&
          txOut == other.txOut &&
          waitstakeCompleteEpoch == other.waitstakeCompleteEpoch &&
          withdrawal == other.withdrawal);

  @override
  int get hashCode =>
      actualRewardsCompleteEpoch.hashCode ^
      blockNo.hashCode ^
      delegation.hashCode ^
      deletedBlock.hashCode ^
      epochNo.hashCode ^
      epochParams.hashCode ^
      forecastRewardsCompleteEpoch.hashCode ^
      maTxMint.hashCode ^
      maTxOut.hashCode ^
      newRewardsCompleteEpoch.hashCode ^
      poolActualsCalculatedEpoch.hashCode ^
      poolForecastCalculatedEpoch.hashCode ^
      poolRetire.hashCode ^
      poolUpdate.hashCode ^
      portfolios.hashCode ^
      reserve.hashCode ^
      reward.hashCode ^
      stakeDeregistration.hashCode ^
      test.hashCode ^
      treasury.hashCode ^
      txIn.hashCode ^
      txOut.hashCode ^
      waitstakeCompleteEpoch.hashCode ^
      withdrawal.hashCode;

  @override
  String toString() {
    return 'MaryDbSyncStatusModel{ actualRewardsCompleteEpoch: $actualRewardsCompleteEpoch, blockNo: $blockNo, delegation: $delegation, deletedBlock: $deletedBlock, epochNo: $epochNo, epochParams: $epochParams, forecastRewardsCompleteEpoch: $forecastRewardsCompleteEpoch, maTxMint: $maTxMint, maTxOut: $maTxOut, newRewardsCompleteEpoch: $newRewardsCompleteEpoch, poolActualsCalculatedEpoch: $poolActualsCalculatedEpoch, poolForecastCalculatedEpoch: $poolForecastCalculatedEpoch, poolRetire: $poolRetire, poolUpdate: $poolUpdate, portfolios: $portfolios, reserve: $reserve, reward: $reward, stakeDeregistration: $stakeDeregistration, test: $test, treasury: $treasury, txIn: $txIn, txOut: $txOut, waitstakeCompleteEpoch: $waitstakeCompleteEpoch, withdrawal: $withdrawal,}';
  }

  MaryDbSyncStatus copyWith({
    num? actualRewardsCompleteEpoch,
    num? blockNo,
    num? delegation,
    String? deletedBlock,
    num? epochNo,
    num? epochParams,
    num? forecastRewardsCompleteEpoch,
    num? maTxMint,
    num? maTxOut,
    num? newRewardsCompleteEpoch,
    num? poolActualsCalculatedEpoch,
    num? poolForecastCalculatedEpoch,
    num? poolRetire,
    num? poolUpdate,
    num? portfolios,
    num? reserve,
    num? reward,
    num? stakeDeregistration,
    num? test,
    num? treasury,
    num? txIn,
    num? txOut,
    num? waitstakeCompleteEpoch,
    num? withdrawal,
  }) {
    return MaryDbSyncStatus(
      actualRewardsCompleteEpoch:
          actualRewardsCompleteEpoch ?? this.actualRewardsCompleteEpoch,
      blockNo: blockNo ?? this.blockNo,
      delegation: delegation ?? this.delegation,
      deletedBlock: deletedBlock ?? this.deletedBlock,
      epochNo: epochNo ?? this.epochNo,
      epochParams: epochParams ?? this.epochParams,
      forecastRewardsCompleteEpoch:
          forecastRewardsCompleteEpoch ?? this.forecastRewardsCompleteEpoch,
      maTxMint: maTxMint ?? this.maTxMint,
      maTxOut: maTxOut ?? this.maTxOut,
      newRewardsCompleteEpoch:
          newRewardsCompleteEpoch ?? this.newRewardsCompleteEpoch,
      poolActualsCalculatedEpoch:
          poolActualsCalculatedEpoch ?? this.poolActualsCalculatedEpoch,
      poolForecastCalculatedEpoch:
          poolForecastCalculatedEpoch ?? this.poolForecastCalculatedEpoch,
      poolRetire: poolRetire ?? this.poolRetire,
      poolUpdate: poolUpdate ?? this.poolUpdate,
      portfolios: portfolios ?? this.portfolios,
      reserve: reserve ?? this.reserve,
      reward: reward ?? this.reward,
      stakeDeregistration: stakeDeregistration ?? this.stakeDeregistration,
      test: test ?? this.test,
      treasury: treasury ?? this.treasury,
      txIn: txIn ?? this.txIn,
      txOut: txOut ?? this.txOut,
      waitstakeCompleteEpoch:
          waitstakeCompleteEpoch ?? this.waitstakeCompleteEpoch,
      withdrawal: withdrawal ?? this.withdrawal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'actualRewardsCompleteEpoch': actualRewardsCompleteEpoch,
      'blockNo': blockNo,
      'delegation': delegation,
      'deletedBlock': deletedBlock,
      'epochNo': epochNo,
      'epochParams': epochParams,
      'forecastRewardsCompleteEpoch': forecastRewardsCompleteEpoch,
      'maTxMint': maTxMint,
      'maTxOut': maTxOut,
      'newRewardsCompleteEpoch': newRewardsCompleteEpoch,
      'poolActualsCalculatedEpoch': poolActualsCalculatedEpoch,
      'poolForecastCalculatedEpoch': poolForecastCalculatedEpoch,
      'poolRetire': poolRetire,
      'poolUpdate': poolUpdate,
      'portfolios': portfolios,
      'reserve': reserve,
      'reward': reward,
      'stakeDeregistration': stakeDeregistration,
      'test': test,
      'treasury': treasury,
      'txIn': txIn,
      'txOut': txOut,
      'waitstakeCompleteEpoch': waitstakeCompleteEpoch,
      'withdrawal': withdrawal,
    };
  }

  factory MaryDbSyncStatus.fromMap(Map<dynamic, dynamic> map) {
    return MaryDbSyncStatus(
      actualRewardsCompleteEpoch: map['actual_rewards_complete_epoch'],
      blockNo: map['block_no'],
      delegation: map['delegation'],
      deletedBlock: map['deleted_block'],
      epochNo: map['epoch_no'],
      epochParams: map['epoch_params'],
      forecastRewardsCompleteEpoch: map['forecast_rewards_complete_epoch'],
      maTxMint: map['ma_tx_mint'],
      maTxOut: map['ma_tx_out'],
      newRewardsCompleteEpoch: map['new_rewards_complete_epoch'],
      poolActualsCalculatedEpoch: map['pool_actuals_calculated_epoch'],
      poolForecastCalculatedEpoch: map['pool_forecast_calculated_epoch'],
      poolRetire: map['pool_retire'],
      poolUpdate: map['pool_update'],
      portfolios: map['portfolios'],
      reserve: map['reserve'],
      reward: map['reward'],
      stakeDeregistration: map['stake_deregistration'],
      test: map['test'],
      treasury: map['treasury'],
      txIn: map['tx_in'],
      txOut: map['tx_out'],
      waitstakeCompleteEpoch: map['waitstake_complete_epoch'],
      withdrawal: map['withdrawal'],
    );
  }

//</editor-fold>
}
