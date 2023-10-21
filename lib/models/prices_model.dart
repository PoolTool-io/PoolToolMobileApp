class Prices {
  num? ada;
  num? aed;
  num? ars;
  num? aud;
  num? bch;
  num? bdt;
  num? bhd;
  num? bmd;
  num? bnb;
  num? brl;
  num? btc;
  num? cad;
  num? chf;
  num? clp;
  num? cny;
  num? czk;
  num? dkk;
  num? dot;
  num? eos;
  num? eth;
  num? eur;
  num? gbp;
  num? hkd;
  num? huf;
  num? idr;
  num? ils;
  num? inr;
  num? jpy;
  num? krw;
  num? kwd;
  num? link;
  num? lkr;
  num? ltc;
  num? mmk;
  num? mxn;
  num? myr;
  num? nok;
  num? nzd;
  num? php;
  num? pkr;
  num? pln;
  num? rub;
  num? sar;
  num? sek;
  num? sgd;
  num? thb;
  num? tryRK; // try is a Reserved Keyword....therefore the RK
  num? twd;
  num? uah;
  num? usd;
  num? vef;
  num? vnd;
  num? xag;
  num? xau;
  num? xdr;
  num? xlm;
  num? xrp;
  num? yfi;
  num? zar;

//<editor-fold desc="Data Methods">

  Prices({
    this.ada,
    this.aed,
    this.ars,
    this.aud,
    this.bch,
    this.bdt,
    this.bhd,
    this.bmd,
    this.bnb,
    this.brl,
    this.btc,
    this.cad,
    this.chf,
    this.clp,
    this.cny,
    this.czk,
    this.dkk,
    this.dot,
    this.eos,
    this.eth,
    this.eur,
    this.gbp,
    this.hkd,
    this.huf,
    this.idr,
    this.ils,
    this.inr,
    this.jpy,
    this.krw,
    this.kwd,
    this.link,
    this.lkr,
    this.ltc,
    this.mmk,
    this.mxn,
    this.myr,
    this.nok,
    this.nzd,
    this.php,
    this.pkr,
    this.pln,
    this.rub,
    this.sar,
    this.sek,
    this.sgd,
    this.thb,
    this.tryRK,
    this.twd,
    this.uah,
    this.usd,
    this.vef,
    this.vnd,
    this.xag,
    this.xau,
    this.xdr,
    this.xlm,
    this.xrp,
    this.yfi,
    this.zar,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prices &&
          runtimeType == other.runtimeType &&
          ada == other.ada &&
          aed == other.aed &&
          ars == other.ars &&
          aud == other.aud &&
          bch == other.bch &&
          bdt == other.bdt &&
          bhd == other.bhd &&
          bmd == other.bmd &&
          bnb == other.bnb &&
          brl == other.brl &&
          btc == other.btc &&
          cad == other.cad &&
          chf == other.chf &&
          clp == other.clp &&
          cny == other.cny &&
          czk == other.czk &&
          dkk == other.dkk &&
          dot == other.dot &&
          eos == other.eos &&
          eth == other.eth &&
          eur == other.eur &&
          gbp == other.gbp &&
          hkd == other.hkd &&
          huf == other.huf &&
          idr == other.idr &&
          ils == other.ils &&
          inr == other.inr &&
          jpy == other.jpy &&
          krw == other.krw &&
          kwd == other.kwd &&
          link == other.link &&
          lkr == other.lkr &&
          ltc == other.ltc &&
          mmk == other.mmk &&
          mxn == other.mxn &&
          myr == other.myr &&
          nok == other.nok &&
          nzd == other.nzd &&
          php == other.php &&
          pkr == other.pkr &&
          pln == other.pln &&
          rub == other.rub &&
          sar == other.sar &&
          sek == other.sek &&
          sgd == other.sgd &&
          thb == other.thb &&
          tryRK == other.tryRK &&
          twd == other.twd &&
          uah == other.uah &&
          usd == other.usd &&
          vef == other.vef &&
          vnd == other.vnd &&
          xag == other.xag &&
          xau == other.xau &&
          xdr == other.xdr &&
          xlm == other.xlm &&
          xrp == other.xrp &&
          yfi == other.yfi &&
          zar == other.zar);

  @override
  int get hashCode =>
      ada.hashCode ^
      aed.hashCode ^
      ars.hashCode ^
      aud.hashCode ^
      bch.hashCode ^
      bdt.hashCode ^
      bhd.hashCode ^
      bmd.hashCode ^
      bnb.hashCode ^
      brl.hashCode ^
      btc.hashCode ^
      cad.hashCode ^
      chf.hashCode ^
      clp.hashCode ^
      cny.hashCode ^
      czk.hashCode ^
      dkk.hashCode ^
      dot.hashCode ^
      eos.hashCode ^
      eth.hashCode ^
      eur.hashCode ^
      gbp.hashCode ^
      hkd.hashCode ^
      huf.hashCode ^
      idr.hashCode ^
      ils.hashCode ^
      inr.hashCode ^
      jpy.hashCode ^
      krw.hashCode ^
      kwd.hashCode ^
      link.hashCode ^
      lkr.hashCode ^
      ltc.hashCode ^
      mmk.hashCode ^
      mxn.hashCode ^
      myr.hashCode ^
      nok.hashCode ^
      nzd.hashCode ^
      php.hashCode ^
      pkr.hashCode ^
      pln.hashCode ^
      rub.hashCode ^
      sar.hashCode ^
      sek.hashCode ^
      sgd.hashCode ^
      thb.hashCode ^
      tryRK.hashCode ^
      twd.hashCode ^
      uah.hashCode ^
      usd.hashCode ^
      vef.hashCode ^
      vnd.hashCode ^
      xag.hashCode ^
      xau.hashCode ^
      xdr.hashCode ^
      xlm.hashCode ^
      xrp.hashCode ^
      yfi.hashCode ^
      zar.hashCode;

  @override
  String toString() {
    return 'Prices{ ada: $ada, aed: $aed, ars: $ars, aud: $aud, bch: $bch, bdt: $bdt, bhd: $bhd, bmd: $bmd, bnb: $bnb, brl: $brl, btc: $btc, cad: $cad, chf: $chf, clp: $clp, cny: $cny, czk: $czk, dkk: $dkk, dot: $dot, eos: $eos, eth: $eth, eur: $eur, gbp: $gbp, hkd: $hkd, huf: $huf, idr: $idr, ils: $ils, inr: $inr, jpy: $jpy, krw: $krw, kwd: $kwd, link: $link, lkr: $lkr, ltc: $ltc, mmk: $mmk, mxn: $mxn, myr: $myr, nok: $nok, nzd: $nzd, php: $php, pkr: $pkr, pln: $pln, rub: $rub, sar: $sar, sek: $sek, sgd: $sgd, thb: $thb, try: $tryRK, twd: $twd, uah: $uah, usd: $usd, vef: $vef, vnd: $vnd, xag: $xag, xau: $xau, xdr: $xdr, xlm: $xlm, xrp: $xrp, yfi: $yfi, zar: $zar,}';
  }

  Prices copyWith({
    num? ada,
    num? aed,
    num? ars,
    num? aud,
    num? bch,
    num? bdt,
    num? bhd,
    num? bmd,
    num? bnb,
    num? brl,
    num? btc,
    num? cad,
    num? chf,
    num? clp,
    num? cny,
    num? czk,
    num? dkk,
    num? dot,
    num? eos,
    num? eth,
    num? eur,
    num? gbp,
    num? hkd,
    num? huf,
    num? idr,
    num? ils,
    num? inr,
    num? jpy,
    num? krw,
    num? kwd,
    num? link,
    num? lkr,
    num? ltc,
    num? mmk,
    num? mxn,
    num? myr,
    num? nok,
    num? nzd,
    num? php,
    num? pkr,
    num? pln,
    num? rub,
    num? sar,
    num? sek,
    num? sgd,
    num? thb,
    num? tryRK,
    num? twd,
    num? uah,
    num? usd,
    num? vef,
    num? vnd,
    num? xag,
    num? xau,
    num? xdr,
    num? xlm,
    num? xrp,
    num? yfi,
    num? zar,
  }) {
    return Prices(
      ada: ada ?? this.ada,
      aed: aed ?? this.aed,
      ars: ars ?? this.ars,
      aud: aud ?? this.aud,
      bch: bch ?? this.bch,
      bdt: bdt ?? this.bdt,
      bhd: bhd ?? this.bhd,
      bmd: bmd ?? this.bmd,
      bnb: bnb ?? this.bnb,
      brl: brl ?? this.brl,
      btc: btc ?? this.btc,
      cad: cad ?? this.cad,
      chf: chf ?? this.chf,
      clp: clp ?? this.clp,
      cny: cny ?? this.cny,
      czk: czk ?? this.czk,
      dkk: dkk ?? this.dkk,
      dot: dot ?? this.dot,
      eos: eos ?? this.eos,
      eth: eth ?? this.eth,
      eur: eur ?? this.eur,
      gbp: gbp ?? this.gbp,
      hkd: hkd ?? this.hkd,
      huf: huf ?? this.huf,
      idr: idr ?? this.idr,
      ils: ils ?? this.ils,
      inr: inr ?? this.inr,
      jpy: jpy ?? this.jpy,
      krw: krw ?? this.krw,
      kwd: kwd ?? this.kwd,
      link: link ?? this.link,
      lkr: lkr ?? this.lkr,
      ltc: ltc ?? this.ltc,
      mmk: mmk ?? this.mmk,
      mxn: mxn ?? this.mxn,
      myr: myr ?? this.myr,
      nok: nok ?? this.nok,
      nzd: nzd ?? this.nzd,
      php: php ?? this.php,
      pkr: pkr ?? this.pkr,
      pln: pln ?? this.pln,
      rub: rub ?? this.rub,
      sar: sar ?? this.sar,
      sek: sek ?? this.sek,
      sgd: sgd ?? this.sgd,
      thb: thb ?? this.thb,
      tryRK: tryRK ?? this.tryRK,
      twd: twd ?? this.twd,
      uah: uah ?? this.uah,
      usd: usd ?? this.usd,
      vef: vef ?? this.vef,
      vnd: vnd ?? this.vnd,
      xag: xag ?? this.xag,
      xau: xau ?? this.xau,
      xdr: xdr ?? this.xdr,
      xlm: xlm ?? this.xlm,
      xrp: xrp ?? this.xrp,
      yfi: yfi ?? this.yfi,
      zar: zar ?? this.zar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ada': ada,
      'aed': aed,
      'ars': ars,
      'aud': aud,
      'bch': bch,
      'bdt': bdt,
      'bhd': bhd,
      'bmd': bmd,
      'bnb': bnb,
      'brl': brl,
      'btc': btc,
      'cad': cad,
      'chf': chf,
      'clp': clp,
      'cny': cny,
      'czk': czk,
      'dkk': dkk,
      'dot': dot,
      'eos': eos,
      'eth': eth,
      'eur': eur,
      'gbp': gbp,
      'hkd': hkd,
      'huf': huf,
      'idr': idr,
      'ils': ils,
      'inr': inr,
      'jpy': jpy,
      'krw': krw,
      'kwd': kwd,
      'link': link,
      'lkr': lkr,
      'ltc': ltc,
      'mmk': mmk,
      'mxn': mxn,
      'myr': myr,
      'nok': nok,
      'nzd': nzd,
      'php': php,
      'pkr': pkr,
      'pln': pln,
      'rub': rub,
      'sar': sar,
      'sek': sek,
      'sgd': sgd,
      'thb': thb,
      'try': tryRK,
      'twd': twd,
      'uah': uah,
      'usd': usd,
      'vef': vef,
      'vnd': vnd,
      'xag': xag,
      'xau': xau,
      'xdr': xdr,
      'xlm': xlm,
      'xrp': xrp,
      'yfi': yfi,
      'zar': zar,
    };
  }

  factory Prices.fromMap(Map<dynamic, dynamic> map) {
    return Prices(
      ada: map['ada'] as num,
      aed: map['aed'] as num,
      ars: map['ars'] as num,
      aud: map['aud'] as num,
      bch: map['bch'] as num,
      bdt: map['bdt'] as num,
      bhd: map['bhd'] as num,
      bmd: map['bmd'] as num,
      bnb: map['bnb'] as num,
      brl: map['brl'] as num,
      btc: map['btc'] as num,
      cad: map['cad'] as num,
      chf: map['chf'] as num,
      clp: map['clp'] as num,
      cny: map['cny'] as num,
      czk: map['czk'] as num,
      dkk: map['dkk'] as num,
      dot: map['dot'] as num,
      eos: map['eos'] as num,
      eth: map['eth'] as num,
      eur: map['eur'] as num,
      gbp: map['gbp'] as num,
      hkd: map['hkd'] as num,
      huf: map['huf'] as num,
      idr: map['idr'] as num,
      ils: map['ils'] as num,
      inr: map['inr'] as num,
      jpy: map['jpy'] as num,
      krw: map['krw'] as num,
      kwd: map['kwd'] as num,
      link: map['link'] as num,
      lkr: map['lkr'] as num,
      ltc: map['ltc'] as num,
      mmk: map['mmk'] as num,
      mxn: map['mxn'] as num,
      myr: map['myr'] as num,
      nok: map['nok'] as num,
      nzd: map['nzd'] as num,
      php: map['php'] as num,
      pkr: map['pkr'] as num,
      pln: map['pln'] as num,
      rub: map['rub'] as num,
      sar: map['sar'] as num,
      sek: map['sek'] as num,
      sgd: map['sgd'] as num,
      thb: map['thb'] as num,
      tryRK: map['try'] as num,
      twd: map['twd'] as num,
      uah: map['uah'] as num,
      usd: map['usd'] as num,
      vef: map['vef'] as num,
      vnd: map['vnd'] as num,
      xag: map['xag'] as num,
      xau: map['xau'] as num,
      xdr: map['xdr'] as num,
      xlm: map['xlm'] as num,
      xrp: map['xrp'] as num,
      yfi: map['yfi'] as num,
      zar: map['zar'] as num,
    );
  }

//</editor-fold>
}
