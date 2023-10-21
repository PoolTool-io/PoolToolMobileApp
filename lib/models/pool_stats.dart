import 'package:pegasus_tool/models/blocks_model.dart';
import 'package:pegasus_tool/models/delegator_rewards_model.dart';
import 'package:pegasus_tool/models/delegators_model.dart';
import 'package:pegasus_tool/models/pool_fees_model.dart';
import 'package:pegasus_tool/models/ros_model.dart';
import 'package:pegasus_tool/models/stake_model.dart';

class PoolStats {
  List<Blocks?>? blocks;
  num? delegatorCount;
  num? delegatorHash;
  List<Delegators?>? delegators;
  List<DelegatorsRewards?>? delegatorsRewards;
  String? description;
  String? firstEpoch;
  String? homePage;
  String? metadataHash;
  String? metadataUrl;
  List<String>? owners;
  String? poolMDerrorString;
  List<PoolFees?>? poolFees;
  num? ptbs;
  String? publicNote;
  String? rewardAddress;
  List<Ros?>? ros;
  List<Stake?>? stake;

//<editor-fold desc="Data Methods">

  PoolStats({
    this.blocks,
    this.delegatorCount,
    this.delegatorHash,
    this.delegators,
    this.delegatorsRewards,
    this.description,
    this.firstEpoch,
    this.homePage,
    this.metadataHash,
    this.metadataUrl,
    this.owners,
    this.poolMDerrorString,
    this.poolFees,
    this.ptbs,
    this.publicNote,
    this.rewardAddress,
    this.ros,
    this.stake,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PoolStats &&
          runtimeType == other.runtimeType &&
          blocks == other.blocks &&
          delegatorCount == other.delegatorCount &&
          delegatorHash == other.delegatorHash &&
          delegators == other.delegators &&
          delegatorsRewards == other.delegatorsRewards &&
          description == other.description &&
          firstEpoch == other.firstEpoch &&
          homePage == other.homePage &&
          metadataHash == other.metadataHash &&
          metadataUrl == other.metadataUrl &&
          owners == other.owners &&
          poolMDerrorString == other.poolMDerrorString &&
          poolFees == other.poolFees &&
          ptbs == other.ptbs &&
          publicNote == other.publicNote &&
          rewardAddress == other.rewardAddress &&
          ros == other.ros &&
          stake == other.stake);

  @override
  int get hashCode =>
      blocks.hashCode ^
      delegatorCount.hashCode ^
      delegatorHash.hashCode ^
      delegators.hashCode ^
      delegatorsRewards.hashCode ^
      description.hashCode ^
      firstEpoch.hashCode ^
      homePage.hashCode ^
      metadataHash.hashCode ^
      metadataUrl.hashCode ^
      owners.hashCode ^
      poolMDerrorString.hashCode ^
      poolFees.hashCode ^
      ptbs.hashCode ^
      publicNote.hashCode ^
      rewardAddress.hashCode ^
      ros.hashCode ^
      stake.hashCode;

  @override
  String toString() {
    return 'PoolStats{ blocks: $blocks, delegatorCount: $delegatorCount, delegatorHash: $delegatorHash, delegators: $delegators, delegatorsRewards: $delegatorsRewards, description: $description, firstEpoch: $firstEpoch, homePage: $homePage, metadataHash: $metadataHash, metadataUrl: $metadataUrl, owners: $owners, poolMDerrorString: $poolMDerrorString, poolFees: $poolFees, ptbs: $ptbs, publicNote: $publicNote, rewardAddress: $rewardAddress, ros: $ros, stake: $stake,}';
  }

  PoolStats copyWith({
    List<Blocks?>? blocks,
    num? delegatorCount,
    num? delegatorHash,
    List<Delegators?>? delegators,
    List<DelegatorsRewards?>? delegatorsRewards,
    String? description,
    String? firstEpoch,
    String? homePage,
    String? metadataHash,
    String? metadataUrl,
    List<String>? owners,
    String? poolMDerrorString,
    List<PoolFees?>? poolFees,
    num? ptbs,
    String? publicNote,
    String? rewardAddress,
    List<Ros?>? ros,
    List<Stake?>? stake,
  }) {
    return PoolStats(
      blocks: blocks ?? this.blocks,
      delegatorCount: delegatorCount ?? this.delegatorCount,
      delegatorHash: delegatorHash ?? this.delegatorHash,
      delegators: delegators ?? this.delegators,
      delegatorsRewards: delegatorsRewards ?? this.delegatorsRewards,
      description: description ?? this.description,
      firstEpoch: firstEpoch ?? this.firstEpoch,
      homePage: homePage ?? this.homePage,
      metadataHash: metadataHash ?? this.metadataHash,
      metadataUrl: metadataUrl ?? this.metadataUrl,
      owners: owners ?? this.owners,
      poolMDerrorString: poolMDerrorString ?? this.poolMDerrorString,
      poolFees: poolFees ?? this.poolFees,
      ptbs: ptbs ?? this.ptbs,
      publicNote: publicNote ?? this.publicNote,
      rewardAddress: rewardAddress ?? this.rewardAddress,
      ros: ros ?? this.ros,
      stake: stake ?? this.stake,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blocks': blocks,
      'delegatorCount': delegatorCount,
      'delegatorHash': delegatorHash,
      'delegators': delegators,
      'delegatorsRewards': delegatorsRewards,
      'description': description,
      'firstEpoch': firstEpoch,
      'homePage': homePage,
      'metadataHash': metadataHash,
      'metadataUrl': metadataUrl,
      'owners': owners,
      'poolMDerrorString': poolMDerrorString,
      'poolFees': poolFees,
      'ptbs': ptbs,
      'publicNote': publicNote,
      'rewardAddress': rewardAddress,
      'ros': ros,
      'stake': stake,
    };
  }

  factory PoolStats.fromMap(Map<dynamic, dynamic> map) {
    return PoolStats(
      blocks: Blocks.getListBlocks(map['blocks']),
      delegatorCount: map['delegatorCount'],
      delegatorHash: map['delegatorHash'],
      delegators: Delegators.getListDelegators(map['delegators']),
      delegatorsRewards:
          DelegatorsRewards.getListDelegatorsRewards(map['delegators_rewards']),
      description: map['description'],
      firstEpoch: map['firstEpoch'].toString(),
      homePage: map['homePage'],
      metadataHash: map['metadataHash'],
      metadataUrl: map['metadataUrl'],
      owners: map['owners'].cast<String>(),
      poolMDerrorString: map['poolMDerrorString'],
      poolFees: PoolFees.getListPoolFees(map['pool_fees']),
      ptbs: map['ptbs'],
      publicNote: map['public_note'],
      rewardAddress: map['reward_address'],
      ros: Ros.getListRos(map['ros']),
      stake: Stake.getListStake(map['stake']),
    );
  }

//</editor-fold>
}
