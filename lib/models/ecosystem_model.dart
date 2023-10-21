import 'package:pegasus_tool/models/battle_data_model.dart';
import 'package:pegasus_tool/models/prices_model.dart';
import 'package:pegasus_tool/models/protocol_block_versions.dart';
import 'package:pegasus_tool/models/protocol_version_model.dart';

class Ecosystem {
  num? activePools;
  num? activeSlotCoeff;
  num? averageFixedFee;
  num? averagePledge;
  num? averageVariableFee;
  BattleData? battleData;
  num? currentEpoch;
  String? datacentersRelays;
  num? decentralizationLevel;
  num? delegators;
  num? desiredPoolNumber;
  num? epochLength;
  String? iptypesRelays;
  num? maxLiveStake;
  num? offlineRelays;
  num? onlineRelays;
  Prices? prices;
  ProtocolBlockVersions? protocolBlockVersions;
  ProtocolVersions? protocolVersions;
  String? protocolsRelays;
  num? reserves;
  num? rewardpot;
  num? saturated;
  num? saturation;
  num? tickerHash;
  num? totalHonoredPledge;
  num? totalPledge;
  num? totalStaked;
  num? totalUtxo;
  num? treasury;
  num? trendingbattles;

//<editor-fold desc="Data Methods">

  Ecosystem({
    this.activePools,
    this.activeSlotCoeff,
    this.averageFixedFee,
    this.averagePledge,
    this.averageVariableFee,
    this.battleData,
    this.currentEpoch,
    this.datacentersRelays,
    this.decentralizationLevel,
    this.delegators,
    this.desiredPoolNumber,
    this.epochLength,
    this.iptypesRelays,
    this.maxLiveStake,
    this.offlineRelays,
    this.onlineRelays,
    this.prices,
    this.protocolBlockVersions,
    this.protocolVersions,
    this.protocolsRelays,
    this.reserves,
    this.rewardpot,
    this.saturated,
    this.saturation,
    this.tickerHash,
    this.totalHonoredPledge,
    this.totalPledge,
    this.totalStaked,
    this.totalUtxo,
    this.treasury,
    this.trendingbattles,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ecosystem &&
          runtimeType == other.runtimeType &&
          activePools == other.activePools &&
          activeSlotCoeff == other.activeSlotCoeff &&
          averageFixedFee == other.averageFixedFee &&
          averagePledge == other.averagePledge &&
          averageVariableFee == other.averageVariableFee &&
          battleData == other.battleData &&
          currentEpoch == other.currentEpoch &&
          datacentersRelays == other.datacentersRelays &&
          decentralizationLevel == other.decentralizationLevel &&
          delegators == other.delegators &&
          desiredPoolNumber == other.desiredPoolNumber &&
          epochLength == other.epochLength &&
          iptypesRelays == other.iptypesRelays &&
          maxLiveStake == other.maxLiveStake &&
          offlineRelays == other.offlineRelays &&
          onlineRelays == other.onlineRelays &&
          prices == other.prices &&
          protocolBlockVersions == other.protocolBlockVersions &&
          protocolVersions == other.protocolVersions &&
          protocolsRelays == other.protocolsRelays &&
          reserves == other.reserves &&
          rewardpot == other.rewardpot &&
          saturated == other.saturated &&
          saturation == other.saturation &&
          tickerHash == other.tickerHash &&
          totalHonoredPledge == other.totalHonoredPledge &&
          totalPledge == other.totalPledge &&
          totalStaked == other.totalStaked &&
          totalUtxo == other.totalUtxo &&
          treasury == other.treasury &&
          trendingbattles == other.trendingbattles);

  @override
  int get hashCode =>
      activePools.hashCode ^
      activeSlotCoeff.hashCode ^
      averageFixedFee.hashCode ^
      averagePledge.hashCode ^
      averageVariableFee.hashCode ^
      battleData.hashCode ^
      currentEpoch.hashCode ^
      datacentersRelays.hashCode ^
      decentralizationLevel.hashCode ^
      delegators.hashCode ^
      desiredPoolNumber.hashCode ^
      epochLength.hashCode ^
      iptypesRelays.hashCode ^
      maxLiveStake.hashCode ^
      offlineRelays.hashCode ^
      onlineRelays.hashCode ^
      prices.hashCode ^
      protocolBlockVersions.hashCode ^
      protocolVersions.hashCode ^
      protocolsRelays.hashCode ^
      reserves.hashCode ^
      rewardpot.hashCode ^
      saturated.hashCode ^
      saturation.hashCode ^
      tickerHash.hashCode ^
      totalHonoredPledge.hashCode ^
      totalPledge.hashCode ^
      totalStaked.hashCode ^
      totalUtxo.hashCode ^
      treasury.hashCode ^
      trendingbattles.hashCode;

  @override
  String toString() {
    return 'EcosystemModel{ activePools: $activePools, activeSlotCoeff: $activeSlotCoeff, averageFixedFee: $averageFixedFee, averagePledge: $averagePledge, averageVariableFee: $averageVariableFee, battleData: $battleData, currentEpoch: $currentEpoch, datacentersRelays: $datacentersRelays, decentralizationLevel: $decentralizationLevel, delegators: $delegators, desiredPoolNumber: $desiredPoolNumber, epochLength: $epochLength, iptypesRelays: $iptypesRelays, maxLiveStake: $maxLiveStake, offlineRelays: $offlineRelays, onlineRelays: $onlineRelays, prices: $prices, protocolBlockVersions: $protocolBlockVersions, protocolVersions: $protocolVersions, protocolsRelays: $protocolsRelays, reserves: $reserves, rewardpot: $rewardpot, saturated: $saturated, saturation: $saturation, tickerHash: $tickerHash, totalHonoredPledge: $totalHonoredPledge, totalPledge: $totalPledge, totalStaked: $totalStaked, totalUtxo: $totalUtxo, treasury: $treasury, trendingbattles: $trendingbattles,}';
  }

  Ecosystem copyWith({
    num? activePools,
    num? activeSlotCoeff,
    num? averageFixedFee,
    num? averagePledge,
    num? averageVariableFee,
    BattleData? battleData,
    num? currentEpoch,
    String? datacentersRelays,
    num? decentralizationLevel,
    num? delegators,
    num? desiredPoolNumber,
    num? epochLength,
    String? iptypesRelays,
    num? maxLiveStake,
    num? offlineRelays,
    num? onlineRelays,
    Prices? prices,
    ProtocolBlockVersions? protocolBlockVersions,
    ProtocolVersions? protocolVersions,
    String? protocolsRelays,
    num? reserves,
    num? rewardpot,
    num? saturated,
    num? saturation,
    num? tickerHash,
    num? totalHonoredPledge,
    num? totalPledge,
    num? totalStaked,
    num? totalUtxo,
    num? treasury,
    num? trendingbattles,
  }) {
    return Ecosystem(
      activePools: activePools ?? this.activePools,
      activeSlotCoeff: activeSlotCoeff ?? this.activeSlotCoeff,
      averageFixedFee: averageFixedFee ?? this.averageFixedFee,
      averagePledge: averagePledge ?? this.averagePledge,
      averageVariableFee: averageVariableFee ?? this.averageVariableFee,
      battleData: battleData ?? this.battleData,
      currentEpoch: currentEpoch ?? this.currentEpoch,
      datacentersRelays: datacentersRelays ?? this.datacentersRelays,
      decentralizationLevel:
          decentralizationLevel ?? this.decentralizationLevel,
      delegators: delegators ?? this.delegators,
      desiredPoolNumber: desiredPoolNumber ?? this.desiredPoolNumber,
      epochLength: epochLength ?? this.epochLength,
      iptypesRelays: iptypesRelays ?? this.iptypesRelays,
      maxLiveStake: maxLiveStake ?? this.maxLiveStake,
      offlineRelays: offlineRelays ?? this.offlineRelays,
      onlineRelays: onlineRelays ?? this.onlineRelays,
      prices: prices ?? this.prices,
      protocolBlockVersions:
          protocolBlockVersions ?? this.protocolBlockVersions,
      protocolVersions: protocolVersions ?? this.protocolVersions,
      protocolsRelays: protocolsRelays ?? this.protocolsRelays,
      reserves: reserves ?? this.reserves,
      rewardpot: rewardpot ?? this.rewardpot,
      saturated: saturated ?? this.saturated,
      saturation: saturation ?? this.saturation,
      tickerHash: tickerHash ?? this.tickerHash,
      totalHonoredPledge: totalHonoredPledge ?? this.totalHonoredPledge,
      totalPledge: totalPledge ?? this.totalPledge,
      totalStaked: totalStaked ?? this.totalStaked,
      totalUtxo: totalUtxo ?? this.totalUtxo,
      treasury: treasury ?? this.treasury,
      trendingbattles: trendingbattles ?? this.trendingbattles,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'activePools': activePools,
      'activeSlotCoeff': activeSlotCoeff,
      'averageFixedFee': averageFixedFee,
      'averagePledge': averagePledge,
      'averageVariableFee': averageVariableFee,
      'battleData': battleData,
      'currentEpoch': currentEpoch,
      'datacentersRelays': datacentersRelays,
      'decentralizationLevel': decentralizationLevel,
      'delegators': delegators,
      'desiredPoolNumber': desiredPoolNumber,
      'epochLength': epochLength,
      'iptypesRelays': iptypesRelays,
      'maxLiveStake': maxLiveStake,
      'offlineRelays': offlineRelays,
      'onlineRelays': onlineRelays,
      'prices': prices,
      'protocolBlockVersions': protocolBlockVersions,
      'protocolVersions': protocolVersions,
      'protocolsRelays': protocolsRelays,
      'reserves': reserves,
      'rewardpot': rewardpot,
      'saturated': saturated,
      'saturation': saturation,
      'tickerHash': tickerHash,
      'totalHonoredPledge': totalHonoredPledge,
      'totalPledge': totalPledge,
      'totalStaked': totalStaked,
      'totalUtxo': totalUtxo,
      'treasury': treasury,
      'trendingbattles': trendingbattles,
    };
  }

  factory Ecosystem.fromMap(Map<dynamic, dynamic> map) {
    return Ecosystem(
      activePools: map['activePools'],
      activeSlotCoeff: map['activeSlotCoeff'],
      averageFixedFee: map['averageFixedFee'],
      averagePledge: map['averagePledge'],
      averageVariableFee: map['averageVariableFee'],
      battleData: BattleData.fromMap(map['battleData']),
      currentEpoch: map['currentEpoch'],
      datacentersRelays: map['datacentersRelays'],
      decentralizationLevel: map['decentralizationLevel'],
      delegators: map['delegators'],
      desiredPoolNumber: map['desiredPoolNumber'],
      epochLength: map['epochLength'],
      iptypesRelays: map['iptypesRelays'],
      maxLiveStake: map['maxLiveStake'],
      offlineRelays: map['offlineRelays'],
      onlineRelays: map['onlineRelays'],
      prices: Prices.fromMap(map['prices']),
      protocolBlockVersions:
          ProtocolBlockVersions.fromMap(map['protocolBlockVersions']),
      protocolVersions: ProtocolVersions.fromMap(map['protocolVersions']),
      protocolsRelays: map['protocolsRelays'],
      reserves: map['reserves'],
      rewardpot: map['rewardpot'],
      saturated: map['saturated'],
      saturation: map['saturation'],
      tickerHash: map['tickerHash'],
      totalHonoredPledge: map['totalHonoredPledge'],
      totalPledge: map['totalPledge'],
      totalStaked: map['totalStaked'],
      totalUtxo: map['totalUtxo'],
      treasury: map['treasury'],
      trendingbattles: map['trendingbattles'],
    );
  }

//</editor-fold>
}
