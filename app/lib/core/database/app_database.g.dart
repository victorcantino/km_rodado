// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsuariosTable extends Usuarios with TableInfo<$UsuariosTable, Usuario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _senhaMeta = const VerificationMeta('senha');
  @override
  late final GeneratedColumn<String> senha = GeneratedColumn<String>(
    'senha',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dataCriacaoMeta = const VerificationMeta(
    'dataCriacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataCriacao = GeneratedColumn<DateTime>(
    'data_criacao',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    email,
    senha,
    dataCriacao,
    ativo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuarios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Usuario> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('senha')) {
      context.handle(
        _senhaMeta,
        senha.isAcceptableOrUnknown(data['senha']!, _senhaMeta),
      );
    }
    if (data.containsKey('data_criacao')) {
      context.handle(
        _dataCriacaoMeta,
        dataCriacao.isAcceptableOrUnknown(
          data['data_criacao']!,
          _dataCriacaoMeta,
        ),
      );
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Usuario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Usuario(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      senha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}senha'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
    );
  }

  @override
  $UsuariosTable createAlias(String alias) {
    return $UsuariosTable(attachedDatabase, alias);
  }
}

class Usuario extends DataClass implements Insertable<Usuario> {
  final int id;
  final String nome;
  final String? email;
  final String? senha;
  final DateTime dataCriacao;
  final bool ativo;
  const Usuario({
    required this.id,
    required this.nome,
    this.email,
    this.senha,
    required this.dataCriacao,
    required this.ativo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || senha != null) {
      map['senha'] = Variable<String>(senha);
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    map['ativo'] = Variable<bool>(ativo);
    return map;
  }

  UsuariosCompanion toCompanion(bool nullToAbsent) {
    return UsuariosCompanion(
      id: Value(id),
      nome: Value(nome),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      senha: senha == null && nullToAbsent
          ? const Value.absent()
          : Value(senha),
      dataCriacao: Value(dataCriacao),
      ativo: Value(ativo),
    );
  }

  factory Usuario.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Usuario(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      email: serializer.fromJson<String?>(json['email']),
      senha: serializer.fromJson<String?>(json['senha']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      ativo: serializer.fromJson<bool>(json['ativo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'email': serializer.toJson<String?>(email),
      'senha': serializer.toJson<String?>(senha),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'ativo': serializer.toJson<bool>(ativo),
    };
  }

  Usuario copyWith({
    int? id,
    String? nome,
    Value<String?> email = const Value.absent(),
    Value<String?> senha = const Value.absent(),
    DateTime? dataCriacao,
    bool? ativo,
  }) => Usuario(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    email: email.present ? email.value : this.email,
    senha: senha.present ? senha.value : this.senha,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    ativo: ativo ?? this.ativo,
  );
  Usuario copyWithCompanion(UsuariosCompanion data) {
    return Usuario(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      email: data.email.present ? data.email.value : this.email,
      senha: data.senha.present ? data.senha.value : this.senha,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Usuario(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('email: $email, ')
          ..write('senha: $senha, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('ativo: $ativo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, email, senha, dataCriacao, ativo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Usuario &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.email == this.email &&
          other.senha == this.senha &&
          other.dataCriacao == this.dataCriacao &&
          other.ativo == this.ativo);
}

class UsuariosCompanion extends UpdateCompanion<Usuario> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String?> email;
  final Value<String?> senha;
  final Value<DateTime> dataCriacao;
  final Value<bool> ativo;
  const UsuariosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.email = const Value.absent(),
    this.senha = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.ativo = const Value.absent(),
  });
  UsuariosCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.email = const Value.absent(),
    this.senha = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.ativo = const Value.absent(),
  }) : nome = Value(nome);
  static Insertable<Usuario> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? email,
    Expression<String>? senha,
    Expression<DateTime>? dataCriacao,
    Expression<bool>? ativo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (email != null) 'email': email,
      if (senha != null) 'senha': senha,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (ativo != null) 'ativo': ativo,
    });
  }

  UsuariosCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String?>? email,
    Value<String?>? senha,
    Value<DateTime>? dataCriacao,
    Value<bool>? ativo,
  }) {
    return UsuariosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      ativo: ativo ?? this.ativo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (senha.present) {
      map['senha'] = Variable<String>(senha.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('email: $email, ')
          ..write('senha: $senha, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('ativo: $ativo')
          ..write(')'))
        .toString();
  }
}

class $VeiculosTable extends Veiculos with TableInfo<$VeiculosTable, Veiculo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VeiculosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _marcaMeta = const VerificationMeta('marca');
  @override
  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
    'marca',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeloMeta = const VerificationMeta('modelo');
  @override
  late final GeneratedColumn<String> modelo = GeneratedColumn<String>(
    'modelo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anoMeta = const VerificationMeta('ano');
  @override
  late final GeneratedColumn<int> ano = GeneratedColumn<int>(
    'ano',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placaMeta = const VerificationMeta('placa');
  @override
  late final GeneratedColumn<String> placa = GeneratedColumn<String>(
    'placa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dataCompraMeta = const VerificationMeta(
    'dataCompra',
  );
  @override
  late final GeneratedColumn<DateTime> dataCompra = GeneratedColumn<DateTime>(
    'data_compra',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quilometragemCompraMeta =
      const VerificationMeta('quilometragemCompra');
  @override
  late final GeneratedColumn<int> quilometragemCompra = GeneratedColumn<int>(
    'quilometragem_compra',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valorCompraMeta = const VerificationMeta(
    'valorCompra',
  );
  @override
  late final GeneratedColumn<double> valorCompra = GeneratedColumn<double>(
    'valor_compra',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valorVendaEstimadoMeta =
      const VerificationMeta('valorVendaEstimado');
  @override
  late final GeneratedColumn<double> valorVendaEstimado =
      GeneratedColumn<double>(
        'valor_venda_estimado',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _capacidadeTanqueMeta = const VerificationMeta(
    'capacidadeTanque',
  );
  @override
  late final GeneratedColumn<double> capacidadeTanque = GeneratedColumn<double>(
    'capacidade_tanque',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(41),
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _observacoesMeta = const VerificationMeta(
    'observacoes',
  );
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
    'observacoes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    usuarioId,
    marca,
    modelo,
    ano,
    placa,
    dataCompra,
    quilometragemCompra,
    valorCompra,
    valorVendaEstimado,
    capacidadeTanque,
    ativo,
    observacoes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'veiculos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Veiculo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('marca')) {
      context.handle(
        _marcaMeta,
        marca.isAcceptableOrUnknown(data['marca']!, _marcaMeta),
      );
    } else if (isInserting) {
      context.missing(_marcaMeta);
    }
    if (data.containsKey('modelo')) {
      context.handle(
        _modeloMeta,
        modelo.isAcceptableOrUnknown(data['modelo']!, _modeloMeta),
      );
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    if (data.containsKey('ano')) {
      context.handle(
        _anoMeta,
        ano.isAcceptableOrUnknown(data['ano']!, _anoMeta),
      );
    } else if (isInserting) {
      context.missing(_anoMeta);
    }
    if (data.containsKey('placa')) {
      context.handle(
        _placaMeta,
        placa.isAcceptableOrUnknown(data['placa']!, _placaMeta),
      );
    }
    if (data.containsKey('data_compra')) {
      context.handle(
        _dataCompraMeta,
        dataCompra.isAcceptableOrUnknown(data['data_compra']!, _dataCompraMeta),
      );
    }
    if (data.containsKey('quilometragem_compra')) {
      context.handle(
        _quilometragemCompraMeta,
        quilometragemCompra.isAcceptableOrUnknown(
          data['quilometragem_compra']!,
          _quilometragemCompraMeta,
        ),
      );
    }
    if (data.containsKey('valor_compra')) {
      context.handle(
        _valorCompraMeta,
        valorCompra.isAcceptableOrUnknown(
          data['valor_compra']!,
          _valorCompraMeta,
        ),
      );
    }
    if (data.containsKey('valor_venda_estimado')) {
      context.handle(
        _valorVendaEstimadoMeta,
        valorVendaEstimado.isAcceptableOrUnknown(
          data['valor_venda_estimado']!,
          _valorVendaEstimadoMeta,
        ),
      );
    }
    if (data.containsKey('capacidade_tanque')) {
      context.handle(
        _capacidadeTanqueMeta,
        capacidadeTanque.isAcceptableOrUnknown(
          data['capacidade_tanque']!,
          _capacidadeTanqueMeta,
        ),
      );
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    if (data.containsKey('observacoes')) {
      context.handle(
        _observacoesMeta,
        observacoes.isAcceptableOrUnknown(
          data['observacoes']!,
          _observacoesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Veiculo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Veiculo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      marca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca'],
      )!,
      modelo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modelo'],
      )!,
      ano: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ano'],
      )!,
      placa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}placa'],
      ),
      dataCompra: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_compra'],
      ),
      quilometragemCompra: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quilometragem_compra'],
      ),
      valorCompra: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor_compra'],
      ),
      valorVendaEstimado: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor_venda_estimado'],
      ),
      capacidadeTanque: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}capacidade_tanque'],
      )!,
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
      observacoes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacoes'],
      ),
    );
  }

  @override
  $VeiculosTable createAlias(String alias) {
    return $VeiculosTable(attachedDatabase, alias);
  }
}

class Veiculo extends DataClass implements Insertable<Veiculo> {
  final int id;
  final int usuarioId;
  final String marca;
  final String modelo;
  final int ano;
  final String? placa;
  final DateTime? dataCompra;
  final int? quilometragemCompra;
  final double? valorCompra;
  final double? valorVendaEstimado;
  final double capacidadeTanque;
  final bool ativo;
  final String? observacoes;
  const Veiculo({
    required this.id,
    required this.usuarioId,
    required this.marca,
    required this.modelo,
    required this.ano,
    this.placa,
    this.dataCompra,
    this.quilometragemCompra,
    this.valorCompra,
    this.valorVendaEstimado,
    required this.capacidadeTanque,
    required this.ativo,
    this.observacoes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['usuario_id'] = Variable<int>(usuarioId);
    map['marca'] = Variable<String>(marca);
    map['modelo'] = Variable<String>(modelo);
    map['ano'] = Variable<int>(ano);
    if (!nullToAbsent || placa != null) {
      map['placa'] = Variable<String>(placa);
    }
    if (!nullToAbsent || dataCompra != null) {
      map['data_compra'] = Variable<DateTime>(dataCompra);
    }
    if (!nullToAbsent || quilometragemCompra != null) {
      map['quilometragem_compra'] = Variable<int>(quilometragemCompra);
    }
    if (!nullToAbsent || valorCompra != null) {
      map['valor_compra'] = Variable<double>(valorCompra);
    }
    if (!nullToAbsent || valorVendaEstimado != null) {
      map['valor_venda_estimado'] = Variable<double>(valorVendaEstimado);
    }
    map['capacidade_tanque'] = Variable<double>(capacidadeTanque);
    map['ativo'] = Variable<bool>(ativo);
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    return map;
  }

  VeiculosCompanion toCompanion(bool nullToAbsent) {
    return VeiculosCompanion(
      id: Value(id),
      usuarioId: Value(usuarioId),
      marca: Value(marca),
      modelo: Value(modelo),
      ano: Value(ano),
      placa: placa == null && nullToAbsent
          ? const Value.absent()
          : Value(placa),
      dataCompra: dataCompra == null && nullToAbsent
          ? const Value.absent()
          : Value(dataCompra),
      quilometragemCompra: quilometragemCompra == null && nullToAbsent
          ? const Value.absent()
          : Value(quilometragemCompra),
      valorCompra: valorCompra == null && nullToAbsent
          ? const Value.absent()
          : Value(valorCompra),
      valorVendaEstimado: valorVendaEstimado == null && nullToAbsent
          ? const Value.absent()
          : Value(valorVendaEstimado),
      capacidadeTanque: Value(capacidadeTanque),
      ativo: Value(ativo),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
    );
  }

  factory Veiculo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Veiculo(
      id: serializer.fromJson<int>(json['id']),
      usuarioId: serializer.fromJson<int>(json['usuarioId']),
      marca: serializer.fromJson<String>(json['marca']),
      modelo: serializer.fromJson<String>(json['modelo']),
      ano: serializer.fromJson<int>(json['ano']),
      placa: serializer.fromJson<String?>(json['placa']),
      dataCompra: serializer.fromJson<DateTime?>(json['dataCompra']),
      quilometragemCompra: serializer.fromJson<int?>(
        json['quilometragemCompra'],
      ),
      valorCompra: serializer.fromJson<double?>(json['valorCompra']),
      valorVendaEstimado: serializer.fromJson<double?>(
        json['valorVendaEstimado'],
      ),
      capacidadeTanque: serializer.fromJson<double>(json['capacidadeTanque']),
      ativo: serializer.fromJson<bool>(json['ativo']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'usuarioId': serializer.toJson<int>(usuarioId),
      'marca': serializer.toJson<String>(marca),
      'modelo': serializer.toJson<String>(modelo),
      'ano': serializer.toJson<int>(ano),
      'placa': serializer.toJson<String?>(placa),
      'dataCompra': serializer.toJson<DateTime?>(dataCompra),
      'quilometragemCompra': serializer.toJson<int?>(quilometragemCompra),
      'valorCompra': serializer.toJson<double?>(valorCompra),
      'valorVendaEstimado': serializer.toJson<double?>(valorVendaEstimado),
      'capacidadeTanque': serializer.toJson<double>(capacidadeTanque),
      'ativo': serializer.toJson<bool>(ativo),
      'observacoes': serializer.toJson<String?>(observacoes),
    };
  }

  Veiculo copyWith({
    int? id,
    int? usuarioId,
    String? marca,
    String? modelo,
    int? ano,
    Value<String?> placa = const Value.absent(),
    Value<DateTime?> dataCompra = const Value.absent(),
    Value<int?> quilometragemCompra = const Value.absent(),
    Value<double?> valorCompra = const Value.absent(),
    Value<double?> valorVendaEstimado = const Value.absent(),
    double? capacidadeTanque,
    bool? ativo,
    Value<String?> observacoes = const Value.absent(),
  }) => Veiculo(
    id: id ?? this.id,
    usuarioId: usuarioId ?? this.usuarioId,
    marca: marca ?? this.marca,
    modelo: modelo ?? this.modelo,
    ano: ano ?? this.ano,
    placa: placa.present ? placa.value : this.placa,
    dataCompra: dataCompra.present ? dataCompra.value : this.dataCompra,
    quilometragemCompra: quilometragemCompra.present
        ? quilometragemCompra.value
        : this.quilometragemCompra,
    valorCompra: valorCompra.present ? valorCompra.value : this.valorCompra,
    valorVendaEstimado: valorVendaEstimado.present
        ? valorVendaEstimado.value
        : this.valorVendaEstimado,
    capacidadeTanque: capacidadeTanque ?? this.capacidadeTanque,
    ativo: ativo ?? this.ativo,
    observacoes: observacoes.present ? observacoes.value : this.observacoes,
  );
  Veiculo copyWithCompanion(VeiculosCompanion data) {
    return Veiculo(
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      marca: data.marca.present ? data.marca.value : this.marca,
      modelo: data.modelo.present ? data.modelo.value : this.modelo,
      ano: data.ano.present ? data.ano.value : this.ano,
      placa: data.placa.present ? data.placa.value : this.placa,
      dataCompra: data.dataCompra.present
          ? data.dataCompra.value
          : this.dataCompra,
      quilometragemCompra: data.quilometragemCompra.present
          ? data.quilometragemCompra.value
          : this.quilometragemCompra,
      valorCompra: data.valorCompra.present
          ? data.valorCompra.value
          : this.valorCompra,
      valorVendaEstimado: data.valorVendaEstimado.present
          ? data.valorVendaEstimado.value
          : this.valorVendaEstimado,
      capacidadeTanque: data.capacidadeTanque.present
          ? data.capacidadeTanque.value
          : this.capacidadeTanque,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
      observacoes: data.observacoes.present
          ? data.observacoes.value
          : this.observacoes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Veiculo(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('ano: $ano, ')
          ..write('placa: $placa, ')
          ..write('dataCompra: $dataCompra, ')
          ..write('quilometragemCompra: $quilometragemCompra, ')
          ..write('valorCompra: $valorCompra, ')
          ..write('valorVendaEstimado: $valorVendaEstimado, ')
          ..write('capacidadeTanque: $capacidadeTanque, ')
          ..write('ativo: $ativo, ')
          ..write('observacoes: $observacoes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    usuarioId,
    marca,
    modelo,
    ano,
    placa,
    dataCompra,
    quilometragemCompra,
    valorCompra,
    valorVendaEstimado,
    capacidadeTanque,
    ativo,
    observacoes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Veiculo &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.marca == this.marca &&
          other.modelo == this.modelo &&
          other.ano == this.ano &&
          other.placa == this.placa &&
          other.dataCompra == this.dataCompra &&
          other.quilometragemCompra == this.quilometragemCompra &&
          other.valorCompra == this.valorCompra &&
          other.valorVendaEstimado == this.valorVendaEstimado &&
          other.capacidadeTanque == this.capacidadeTanque &&
          other.ativo == this.ativo &&
          other.observacoes == this.observacoes);
}

class VeiculosCompanion extends UpdateCompanion<Veiculo> {
  final Value<int> id;
  final Value<int> usuarioId;
  final Value<String> marca;
  final Value<String> modelo;
  final Value<int> ano;
  final Value<String?> placa;
  final Value<DateTime?> dataCompra;
  final Value<int?> quilometragemCompra;
  final Value<double?> valorCompra;
  final Value<double?> valorVendaEstimado;
  final Value<double> capacidadeTanque;
  final Value<bool> ativo;
  final Value<String?> observacoes;
  const VeiculosCompanion({
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.marca = const Value.absent(),
    this.modelo = const Value.absent(),
    this.ano = const Value.absent(),
    this.placa = const Value.absent(),
    this.dataCompra = const Value.absent(),
    this.quilometragemCompra = const Value.absent(),
    this.valorCompra = const Value.absent(),
    this.valorVendaEstimado = const Value.absent(),
    this.capacidadeTanque = const Value.absent(),
    this.ativo = const Value.absent(),
    this.observacoes = const Value.absent(),
  });
  VeiculosCompanion.insert({
    this.id = const Value.absent(),
    required int usuarioId,
    required String marca,
    required String modelo,
    required int ano,
    this.placa = const Value.absent(),
    this.dataCompra = const Value.absent(),
    this.quilometragemCompra = const Value.absent(),
    this.valorCompra = const Value.absent(),
    this.valorVendaEstimado = const Value.absent(),
    this.capacidadeTanque = const Value.absent(),
    this.ativo = const Value.absent(),
    this.observacoes = const Value.absent(),
  }) : usuarioId = Value(usuarioId),
       marca = Value(marca),
       modelo = Value(modelo),
       ano = Value(ano);
  static Insertable<Veiculo> custom({
    Expression<int>? id,
    Expression<int>? usuarioId,
    Expression<String>? marca,
    Expression<String>? modelo,
    Expression<int>? ano,
    Expression<String>? placa,
    Expression<DateTime>? dataCompra,
    Expression<int>? quilometragemCompra,
    Expression<double>? valorCompra,
    Expression<double>? valorVendaEstimado,
    Expression<double>? capacidadeTanque,
    Expression<bool>? ativo,
    Expression<String>? observacoes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (marca != null) 'marca': marca,
      if (modelo != null) 'modelo': modelo,
      if (ano != null) 'ano': ano,
      if (placa != null) 'placa': placa,
      if (dataCompra != null) 'data_compra': dataCompra,
      if (quilometragemCompra != null)
        'quilometragem_compra': quilometragemCompra,
      if (valorCompra != null) 'valor_compra': valorCompra,
      if (valorVendaEstimado != null)
        'valor_venda_estimado': valorVendaEstimado,
      if (capacidadeTanque != null) 'capacidade_tanque': capacidadeTanque,
      if (ativo != null) 'ativo': ativo,
      if (observacoes != null) 'observacoes': observacoes,
    });
  }

  VeiculosCompanion copyWith({
    Value<int>? id,
    Value<int>? usuarioId,
    Value<String>? marca,
    Value<String>? modelo,
    Value<int>? ano,
    Value<String?>? placa,
    Value<DateTime?>? dataCompra,
    Value<int?>? quilometragemCompra,
    Value<double?>? valorCompra,
    Value<double?>? valorVendaEstimado,
    Value<double>? capacidadeTanque,
    Value<bool>? ativo,
    Value<String?>? observacoes,
  }) {
    return VeiculosCompanion(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      ano: ano ?? this.ano,
      placa: placa ?? this.placa,
      dataCompra: dataCompra ?? this.dataCompra,
      quilometragemCompra: quilometragemCompra ?? this.quilometragemCompra,
      valorCompra: valorCompra ?? this.valorCompra,
      valorVendaEstimado: valorVendaEstimado ?? this.valorVendaEstimado,
      capacidadeTanque: capacidadeTanque ?? this.capacidadeTanque,
      ativo: ativo ?? this.ativo,
      observacoes: observacoes ?? this.observacoes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (marca.present) {
      map['marca'] = Variable<String>(marca.value);
    }
    if (modelo.present) {
      map['modelo'] = Variable<String>(modelo.value);
    }
    if (ano.present) {
      map['ano'] = Variable<int>(ano.value);
    }
    if (placa.present) {
      map['placa'] = Variable<String>(placa.value);
    }
    if (dataCompra.present) {
      map['data_compra'] = Variable<DateTime>(dataCompra.value);
    }
    if (quilometragemCompra.present) {
      map['quilometragem_compra'] = Variable<int>(quilometragemCompra.value);
    }
    if (valorCompra.present) {
      map['valor_compra'] = Variable<double>(valorCompra.value);
    }
    if (valorVendaEstimado.present) {
      map['valor_venda_estimado'] = Variable<double>(valorVendaEstimado.value);
    }
    if (capacidadeTanque.present) {
      map['capacidade_tanque'] = Variable<double>(capacidadeTanque.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VeiculosCompanion(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('ano: $ano, ')
          ..write('placa: $placa, ')
          ..write('dataCompra: $dataCompra, ')
          ..write('quilometragemCompra: $quilometragemCompra, ')
          ..write('valorCompra: $valorCompra, ')
          ..write('valorVendaEstimado: $valorVendaEstimado, ')
          ..write('capacidadeTanque: $capacidadeTanque, ')
          ..write('ativo: $ativo, ')
          ..write('observacoes: $observacoes')
          ..write(')'))
        .toString();
  }
}

class $ConfiguracoesTable extends Configuracoes
    with TableInfo<$ConfiguracoesTable, Configuracoe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfiguracoesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _custoKmBaseMeta = const VerificationMeta(
    'custoKmBase',
  );
  @override
  late final GeneratedColumn<double> custoKmBase = GeneratedColumn<double>(
    'custo_km_base',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _metaKmDiaMeta = const VerificationMeta(
    'metaKmDia',
  );
  @override
  late final GeneratedColumn<int> metaKmDia = GeneratedColumn<int>(
    'meta_km_dia',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _capacidadeTanqueMeta = const VerificationMeta(
    'capacidadeTanque',
  );
  @override
  late final GeneratedColumn<double> capacidadeTanque = GeneratedColumn<double>(
    'capacidade_tanque',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(41),
  );
  static const VerificationMeta _cidadePadraoMeta = const VerificationMeta(
    'cidadePadrao',
  );
  @override
  late final GeneratedColumn<String> cidadePadrao = GeneratedColumn<String>(
    'cidade_padrao',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    usuarioId,
    custoKmBase,
    metaKmDia,
    capacidadeTanque,
    cidadePadrao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configuracoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Configuracoe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('custo_km_base')) {
      context.handle(
        _custoKmBaseMeta,
        custoKmBase.isAcceptableOrUnknown(
          data['custo_km_base']!,
          _custoKmBaseMeta,
        ),
      );
    }
    if (data.containsKey('meta_km_dia')) {
      context.handle(
        _metaKmDiaMeta,
        metaKmDia.isAcceptableOrUnknown(data['meta_km_dia']!, _metaKmDiaMeta),
      );
    }
    if (data.containsKey('capacidade_tanque')) {
      context.handle(
        _capacidadeTanqueMeta,
        capacidadeTanque.isAcceptableOrUnknown(
          data['capacidade_tanque']!,
          _capacidadeTanqueMeta,
        ),
      );
    }
    if (data.containsKey('cidade_padrao')) {
      context.handle(
        _cidadePadraoMeta,
        cidadePadrao.isAcceptableOrUnknown(
          data['cidade_padrao']!,
          _cidadePadraoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Configuracoe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Configuracoe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      custoKmBase: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}custo_km_base'],
      )!,
      metaKmDia: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meta_km_dia'],
      )!,
      capacidadeTanque: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}capacidade_tanque'],
      )!,
      cidadePadrao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cidade_padrao'],
      ),
    );
  }

  @override
  $ConfiguracoesTable createAlias(String alias) {
    return $ConfiguracoesTable(attachedDatabase, alias);
  }
}

class Configuracoe extends DataClass implements Insertable<Configuracoe> {
  final int id;
  final int usuarioId;
  final double custoKmBase;
  final int metaKmDia;
  final double capacidadeTanque;
  final String? cidadePadrao;
  const Configuracoe({
    required this.id,
    required this.usuarioId,
    required this.custoKmBase,
    required this.metaKmDia,
    required this.capacidadeTanque,
    this.cidadePadrao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['usuario_id'] = Variable<int>(usuarioId);
    map['custo_km_base'] = Variable<double>(custoKmBase);
    map['meta_km_dia'] = Variable<int>(metaKmDia);
    map['capacidade_tanque'] = Variable<double>(capacidadeTanque);
    if (!nullToAbsent || cidadePadrao != null) {
      map['cidade_padrao'] = Variable<String>(cidadePadrao);
    }
    return map;
  }

  ConfiguracoesCompanion toCompanion(bool nullToAbsent) {
    return ConfiguracoesCompanion(
      id: Value(id),
      usuarioId: Value(usuarioId),
      custoKmBase: Value(custoKmBase),
      metaKmDia: Value(metaKmDia),
      capacidadeTanque: Value(capacidadeTanque),
      cidadePadrao: cidadePadrao == null && nullToAbsent
          ? const Value.absent()
          : Value(cidadePadrao),
    );
  }

  factory Configuracoe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Configuracoe(
      id: serializer.fromJson<int>(json['id']),
      usuarioId: serializer.fromJson<int>(json['usuarioId']),
      custoKmBase: serializer.fromJson<double>(json['custoKmBase']),
      metaKmDia: serializer.fromJson<int>(json['metaKmDia']),
      capacidadeTanque: serializer.fromJson<double>(json['capacidadeTanque']),
      cidadePadrao: serializer.fromJson<String?>(json['cidadePadrao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'usuarioId': serializer.toJson<int>(usuarioId),
      'custoKmBase': serializer.toJson<double>(custoKmBase),
      'metaKmDia': serializer.toJson<int>(metaKmDia),
      'capacidadeTanque': serializer.toJson<double>(capacidadeTanque),
      'cidadePadrao': serializer.toJson<String?>(cidadePadrao),
    };
  }

  Configuracoe copyWith({
    int? id,
    int? usuarioId,
    double? custoKmBase,
    int? metaKmDia,
    double? capacidadeTanque,
    Value<String?> cidadePadrao = const Value.absent(),
  }) => Configuracoe(
    id: id ?? this.id,
    usuarioId: usuarioId ?? this.usuarioId,
    custoKmBase: custoKmBase ?? this.custoKmBase,
    metaKmDia: metaKmDia ?? this.metaKmDia,
    capacidadeTanque: capacidadeTanque ?? this.capacidadeTanque,
    cidadePadrao: cidadePadrao.present ? cidadePadrao.value : this.cidadePadrao,
  );
  Configuracoe copyWithCompanion(ConfiguracoesCompanion data) {
    return Configuracoe(
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      custoKmBase: data.custoKmBase.present
          ? data.custoKmBase.value
          : this.custoKmBase,
      metaKmDia: data.metaKmDia.present ? data.metaKmDia.value : this.metaKmDia,
      capacidadeTanque: data.capacidadeTanque.present
          ? data.capacidadeTanque.value
          : this.capacidadeTanque,
      cidadePadrao: data.cidadePadrao.present
          ? data.cidadePadrao.value
          : this.cidadePadrao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Configuracoe(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('custoKmBase: $custoKmBase, ')
          ..write('metaKmDia: $metaKmDia, ')
          ..write('capacidadeTanque: $capacidadeTanque, ')
          ..write('cidadePadrao: $cidadePadrao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    usuarioId,
    custoKmBase,
    metaKmDia,
    capacidadeTanque,
    cidadePadrao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Configuracoe &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.custoKmBase == this.custoKmBase &&
          other.metaKmDia == this.metaKmDia &&
          other.capacidadeTanque == this.capacidadeTanque &&
          other.cidadePadrao == this.cidadePadrao);
}

class ConfiguracoesCompanion extends UpdateCompanion<Configuracoe> {
  final Value<int> id;
  final Value<int> usuarioId;
  final Value<double> custoKmBase;
  final Value<int> metaKmDia;
  final Value<double> capacidadeTanque;
  final Value<String?> cidadePadrao;
  const ConfiguracoesCompanion({
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.custoKmBase = const Value.absent(),
    this.metaKmDia = const Value.absent(),
    this.capacidadeTanque = const Value.absent(),
    this.cidadePadrao = const Value.absent(),
  });
  ConfiguracoesCompanion.insert({
    this.id = const Value.absent(),
    required int usuarioId,
    this.custoKmBase = const Value.absent(),
    this.metaKmDia = const Value.absent(),
    this.capacidadeTanque = const Value.absent(),
    this.cidadePadrao = const Value.absent(),
  }) : usuarioId = Value(usuarioId);
  static Insertable<Configuracoe> custom({
    Expression<int>? id,
    Expression<int>? usuarioId,
    Expression<double>? custoKmBase,
    Expression<int>? metaKmDia,
    Expression<double>? capacidadeTanque,
    Expression<String>? cidadePadrao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (custoKmBase != null) 'custo_km_base': custoKmBase,
      if (metaKmDia != null) 'meta_km_dia': metaKmDia,
      if (capacidadeTanque != null) 'capacidade_tanque': capacidadeTanque,
      if (cidadePadrao != null) 'cidade_padrao': cidadePadrao,
    });
  }

  ConfiguracoesCompanion copyWith({
    Value<int>? id,
    Value<int>? usuarioId,
    Value<double>? custoKmBase,
    Value<int>? metaKmDia,
    Value<double>? capacidadeTanque,
    Value<String?>? cidadePadrao,
  }) {
    return ConfiguracoesCompanion(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      custoKmBase: custoKmBase ?? this.custoKmBase,
      metaKmDia: metaKmDia ?? this.metaKmDia,
      capacidadeTanque: capacidadeTanque ?? this.capacidadeTanque,
      cidadePadrao: cidadePadrao ?? this.cidadePadrao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (custoKmBase.present) {
      map['custo_km_base'] = Variable<double>(custoKmBase.value);
    }
    if (metaKmDia.present) {
      map['meta_km_dia'] = Variable<int>(metaKmDia.value);
    }
    if (capacidadeTanque.present) {
      map['capacidade_tanque'] = Variable<double>(capacidadeTanque.value);
    }
    if (cidadePadrao.present) {
      map['cidade_padrao'] = Variable<String>(cidadePadrao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracoesCompanion(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('custoKmBase: $custoKmBase, ')
          ..write('metaKmDia: $metaKmDia, ')
          ..write('capacidadeTanque: $capacidadeTanque, ')
          ..write('cidadePadrao: $cidadePadrao')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsuariosTable usuarios = $UsuariosTable(this);
  late final $VeiculosTable veiculos = $VeiculosTable(this);
  late final $ConfiguracoesTable configuracoes = $ConfiguracoesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    usuarios,
    veiculos,
    configuracoes,
  ];
}

typedef $$UsuariosTableCreateCompanionBuilder =
    UsuariosCompanion Function({
      Value<int> id,
      required String nome,
      Value<String?> email,
      Value<String?> senha,
      Value<DateTime> dataCriacao,
      Value<bool> ativo,
    });
typedef $$UsuariosTableUpdateCompanionBuilder =
    UsuariosCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<String?> email,
      Value<String?> senha,
      Value<DateTime> dataCriacao,
      Value<bool> ativo,
    });

class $$UsuariosTableFilterComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senha => $composableBuilder(
    column: $table.senha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsuariosTableOrderingComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senha => $composableBuilder(
    column: $table.senha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsuariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get senha =>
      $composableBuilder(column: $table.senha, builder: (column) => column);

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);
}

class $$UsuariosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsuariosTable,
          Usuario,
          $$UsuariosTableFilterComposer,
          $$UsuariosTableOrderingComposer,
          $$UsuariosTableAnnotationComposer,
          $$UsuariosTableCreateCompanionBuilder,
          $$UsuariosTableUpdateCompanionBuilder,
          (Usuario, BaseReferences<_$AppDatabase, $UsuariosTable, Usuario>),
          Usuario,
          PrefetchHooks Function()
        > {
  $$UsuariosTableTableManager(_$AppDatabase db, $UsuariosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsuariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsuariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsuariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> senha = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
              }) => UsuariosCompanion(
                id: id,
                nome: nome,
                email: email,
                senha: senha,
                dataCriacao: dataCriacao,
                ativo: ativo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                Value<String?> email = const Value.absent(),
                Value<String?> senha = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
              }) => UsuariosCompanion.insert(
                id: id,
                nome: nome,
                email: email,
                senha: senha,
                dataCriacao: dataCriacao,
                ativo: ativo,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsuariosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsuariosTable,
      Usuario,
      $$UsuariosTableFilterComposer,
      $$UsuariosTableOrderingComposer,
      $$UsuariosTableAnnotationComposer,
      $$UsuariosTableCreateCompanionBuilder,
      $$UsuariosTableUpdateCompanionBuilder,
      (Usuario, BaseReferences<_$AppDatabase, $UsuariosTable, Usuario>),
      Usuario,
      PrefetchHooks Function()
    >;
typedef $$VeiculosTableCreateCompanionBuilder =
    VeiculosCompanion Function({
      Value<int> id,
      required int usuarioId,
      required String marca,
      required String modelo,
      required int ano,
      Value<String?> placa,
      Value<DateTime?> dataCompra,
      Value<int?> quilometragemCompra,
      Value<double?> valorCompra,
      Value<double?> valorVendaEstimado,
      Value<double> capacidadeTanque,
      Value<bool> ativo,
      Value<String?> observacoes,
    });
typedef $$VeiculosTableUpdateCompanionBuilder =
    VeiculosCompanion Function({
      Value<int> id,
      Value<int> usuarioId,
      Value<String> marca,
      Value<String> modelo,
      Value<int> ano,
      Value<String?> placa,
      Value<DateTime?> dataCompra,
      Value<int?> quilometragemCompra,
      Value<double?> valorCompra,
      Value<double?> valorVendaEstimado,
      Value<double> capacidadeTanque,
      Value<bool> ativo,
      Value<String?> observacoes,
    });

class $$VeiculosTableFilterComposer
    extends Composer<_$AppDatabase, $VeiculosTable> {
  $$VeiculosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelo => $composableBuilder(
    column: $table.modelo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ano => $composableBuilder(
    column: $table.ano,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placa => $composableBuilder(
    column: $table.placa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCompra => $composableBuilder(
    column: $table.dataCompra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quilometragemCompra => $composableBuilder(
    column: $table.quilometragemCompra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valorCompra => $composableBuilder(
    column: $table.valorCompra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valorVendaEstimado => $composableBuilder(
    column: $table.valorVendaEstimado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get capacidadeTanque => $composableBuilder(
    column: $table.capacidadeTanque,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VeiculosTableOrderingComposer
    extends Composer<_$AppDatabase, $VeiculosTable> {
  $$VeiculosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelo => $composableBuilder(
    column: $table.modelo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ano => $composableBuilder(
    column: $table.ano,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placa => $composableBuilder(
    column: $table.placa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCompra => $composableBuilder(
    column: $table.dataCompra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quilometragemCompra => $composableBuilder(
    column: $table.quilometragemCompra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valorCompra => $composableBuilder(
    column: $table.valorCompra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valorVendaEstimado => $composableBuilder(
    column: $table.valorVendaEstimado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get capacidadeTanque => $composableBuilder(
    column: $table.capacidadeTanque,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VeiculosTableAnnotationComposer
    extends Composer<_$AppDatabase, $VeiculosTable> {
  $$VeiculosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get marca =>
      $composableBuilder(column: $table.marca, builder: (column) => column);

  GeneratedColumn<String> get modelo =>
      $composableBuilder(column: $table.modelo, builder: (column) => column);

  GeneratedColumn<int> get ano =>
      $composableBuilder(column: $table.ano, builder: (column) => column);

  GeneratedColumn<String> get placa =>
      $composableBuilder(column: $table.placa, builder: (column) => column);

  GeneratedColumn<DateTime> get dataCompra => $composableBuilder(
    column: $table.dataCompra,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quilometragemCompra => $composableBuilder(
    column: $table.quilometragemCompra,
    builder: (column) => column,
  );

  GeneratedColumn<double> get valorCompra => $composableBuilder(
    column: $table.valorCompra,
    builder: (column) => column,
  );

  GeneratedColumn<double> get valorVendaEstimado => $composableBuilder(
    column: $table.valorVendaEstimado,
    builder: (column) => column,
  );

  GeneratedColumn<double> get capacidadeTanque => $composableBuilder(
    column: $table.capacidadeTanque,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  GeneratedColumn<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => column,
  );
}

class $$VeiculosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VeiculosTable,
          Veiculo,
          $$VeiculosTableFilterComposer,
          $$VeiculosTableOrderingComposer,
          $$VeiculosTableAnnotationComposer,
          $$VeiculosTableCreateCompanionBuilder,
          $$VeiculosTableUpdateCompanionBuilder,
          (Veiculo, BaseReferences<_$AppDatabase, $VeiculosTable, Veiculo>),
          Veiculo,
          PrefetchHooks Function()
        > {
  $$VeiculosTableTableManager(_$AppDatabase db, $VeiculosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VeiculosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VeiculosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VeiculosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<String> marca = const Value.absent(),
                Value<String> modelo = const Value.absent(),
                Value<int> ano = const Value.absent(),
                Value<String?> placa = const Value.absent(),
                Value<DateTime?> dataCompra = const Value.absent(),
                Value<int?> quilometragemCompra = const Value.absent(),
                Value<double?> valorCompra = const Value.absent(),
                Value<double?> valorVendaEstimado = const Value.absent(),
                Value<double> capacidadeTanque = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
              }) => VeiculosCompanion(
                id: id,
                usuarioId: usuarioId,
                marca: marca,
                modelo: modelo,
                ano: ano,
                placa: placa,
                dataCompra: dataCompra,
                quilometragemCompra: quilometragemCompra,
                valorCompra: valorCompra,
                valorVendaEstimado: valorVendaEstimado,
                capacidadeTanque: capacidadeTanque,
                ativo: ativo,
                observacoes: observacoes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int usuarioId,
                required String marca,
                required String modelo,
                required int ano,
                Value<String?> placa = const Value.absent(),
                Value<DateTime?> dataCompra = const Value.absent(),
                Value<int?> quilometragemCompra = const Value.absent(),
                Value<double?> valorCompra = const Value.absent(),
                Value<double?> valorVendaEstimado = const Value.absent(),
                Value<double> capacidadeTanque = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
              }) => VeiculosCompanion.insert(
                id: id,
                usuarioId: usuarioId,
                marca: marca,
                modelo: modelo,
                ano: ano,
                placa: placa,
                dataCompra: dataCompra,
                quilometragemCompra: quilometragemCompra,
                valorCompra: valorCompra,
                valorVendaEstimado: valorVendaEstimado,
                capacidadeTanque: capacidadeTanque,
                ativo: ativo,
                observacoes: observacoes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VeiculosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VeiculosTable,
      Veiculo,
      $$VeiculosTableFilterComposer,
      $$VeiculosTableOrderingComposer,
      $$VeiculosTableAnnotationComposer,
      $$VeiculosTableCreateCompanionBuilder,
      $$VeiculosTableUpdateCompanionBuilder,
      (Veiculo, BaseReferences<_$AppDatabase, $VeiculosTable, Veiculo>),
      Veiculo,
      PrefetchHooks Function()
    >;
typedef $$ConfiguracoesTableCreateCompanionBuilder =
    ConfiguracoesCompanion Function({
      Value<int> id,
      required int usuarioId,
      Value<double> custoKmBase,
      Value<int> metaKmDia,
      Value<double> capacidadeTanque,
      Value<String?> cidadePadrao,
    });
typedef $$ConfiguracoesTableUpdateCompanionBuilder =
    ConfiguracoesCompanion Function({
      Value<int> id,
      Value<int> usuarioId,
      Value<double> custoKmBase,
      Value<int> metaKmDia,
      Value<double> capacidadeTanque,
      Value<String?> cidadePadrao,
    });

class $$ConfiguracoesTableFilterComposer
    extends Composer<_$AppDatabase, $ConfiguracoesTable> {
  $$ConfiguracoesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get custoKmBase => $composableBuilder(
    column: $table.custoKmBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get metaKmDia => $composableBuilder(
    column: $table.metaKmDia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get capacidadeTanque => $composableBuilder(
    column: $table.capacidadeTanque,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cidadePadrao => $composableBuilder(
    column: $table.cidadePadrao,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConfiguracoesTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfiguracoesTable> {
  $$ConfiguracoesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get custoKmBase => $composableBuilder(
    column: $table.custoKmBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get metaKmDia => $composableBuilder(
    column: $table.metaKmDia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get capacidadeTanque => $composableBuilder(
    column: $table.capacidadeTanque,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cidadePadrao => $composableBuilder(
    column: $table.cidadePadrao,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConfiguracoesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfiguracoesTable> {
  $$ConfiguracoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<double> get custoKmBase => $composableBuilder(
    column: $table.custoKmBase,
    builder: (column) => column,
  );

  GeneratedColumn<int> get metaKmDia =>
      $composableBuilder(column: $table.metaKmDia, builder: (column) => column);

  GeneratedColumn<double> get capacidadeTanque => $composableBuilder(
    column: $table.capacidadeTanque,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cidadePadrao => $composableBuilder(
    column: $table.cidadePadrao,
    builder: (column) => column,
  );
}

class $$ConfiguracoesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConfiguracoesTable,
          Configuracoe,
          $$ConfiguracoesTableFilterComposer,
          $$ConfiguracoesTableOrderingComposer,
          $$ConfiguracoesTableAnnotationComposer,
          $$ConfiguracoesTableCreateCompanionBuilder,
          $$ConfiguracoesTableUpdateCompanionBuilder,
          (
            Configuracoe,
            BaseReferences<_$AppDatabase, $ConfiguracoesTable, Configuracoe>,
          ),
          Configuracoe,
          PrefetchHooks Function()
        > {
  $$ConfiguracoesTableTableManager(_$AppDatabase db, $ConfiguracoesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfiguracoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfiguracoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfiguracoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<double> custoKmBase = const Value.absent(),
                Value<int> metaKmDia = const Value.absent(),
                Value<double> capacidadeTanque = const Value.absent(),
                Value<String?> cidadePadrao = const Value.absent(),
              }) => ConfiguracoesCompanion(
                id: id,
                usuarioId: usuarioId,
                custoKmBase: custoKmBase,
                metaKmDia: metaKmDia,
                capacidadeTanque: capacidadeTanque,
                cidadePadrao: cidadePadrao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int usuarioId,
                Value<double> custoKmBase = const Value.absent(),
                Value<int> metaKmDia = const Value.absent(),
                Value<double> capacidadeTanque = const Value.absent(),
                Value<String?> cidadePadrao = const Value.absent(),
              }) => ConfiguracoesCompanion.insert(
                id: id,
                usuarioId: usuarioId,
                custoKmBase: custoKmBase,
                metaKmDia: metaKmDia,
                capacidadeTanque: capacidadeTanque,
                cidadePadrao: cidadePadrao,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConfiguracoesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConfiguracoesTable,
      Configuracoe,
      $$ConfiguracoesTableFilterComposer,
      $$ConfiguracoesTableOrderingComposer,
      $$ConfiguracoesTableAnnotationComposer,
      $$ConfiguracoesTableCreateCompanionBuilder,
      $$ConfiguracoesTableUpdateCompanionBuilder,
      (
        Configuracoe,
        BaseReferences<_$AppDatabase, $ConfiguracoesTable, Configuracoe>,
      ),
      Configuracoe,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db, _db.usuarios);
  $$VeiculosTableTableManager get veiculos =>
      $$VeiculosTableTableManager(_db, _db.veiculos);
  $$ConfiguracoesTableTableManager get configuracoes =>
      $$ConfiguracoesTableTableManager(_db, _db.configuracoes);
}
