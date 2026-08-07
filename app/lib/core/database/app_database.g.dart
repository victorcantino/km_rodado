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

class $JornadasTable extends Jornadas with TableInfo<$JornadasTable, Jornada> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JornadasTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES usuarios (id)',
    ),
  );
  static const VerificationMeta _veiculoIdMeta = const VerificationMeta(
    'veiculoId',
  );
  @override
  late final GeneratedColumn<int> veiculoId = GeneratedColumn<int>(
    'veiculo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES veiculos (id)',
    ),
  );
  static const VerificationMeta _dataHoraInicioMeta = const VerificationMeta(
    'dataHoraInicio',
  );
  @override
  late final GeneratedColumn<DateTime> dataHoraInicio =
      GeneratedColumn<DateTime>(
        'data_hora_inicio',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dataHoraFimMeta = const VerificationMeta(
    'dataHoraFim',
  );
  @override
  late final GeneratedColumn<DateTime> dataHoraFim = GeneratedColumn<DateTime>(
    'data_hora_fim',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _odometroInicioMeta = const VerificationMeta(
    'odometroInicio',
  );
  @override
  late final GeneratedColumn<int> odometroInicio = GeneratedColumn<int>(
    'odometro_inicio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometroFimMeta = const VerificationMeta(
    'odometroFim',
  );
  @override
  late final GeneratedColumn<int> odometroFim = GeneratedColumn<int>(
    'odometro_fim',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cidadeOrigemMeta = const VerificationMeta(
    'cidadeOrigem',
  );
  @override
  late final GeneratedColumn<String> cidadeOrigem = GeneratedColumn<String>(
    'cidade_origem',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cidadeDestinoMeta = const VerificationMeta(
    'cidadeDestino',
  );
  @override
  late final GeneratedColumn<String> cidadeDestino = GeneratedColumn<String>(
    'cidade_destino',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StatusJornada, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<StatusJornada>($JornadasTable.$converterstatus);
  static const VerificationMeta _odometroAlteradoMeta = const VerificationMeta(
    'odometroAlterado',
  );
  @override
  late final GeneratedColumn<bool> odometroAlterado = GeneratedColumn<bool>(
    'odometro_alterado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("odometro_alterado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  static const VerificationMeta _dataAtualizacaoMeta = const VerificationMeta(
    'dataAtualizacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataAtualizacao =
      GeneratedColumn<DateTime>(
        'data_atualizacao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _quilometrosPercorridosMeta =
      const VerificationMeta('quilometrosPercorridos');
  @override
  late final GeneratedColumn<int> quilometrosPercorridos = GeneratedColumn<int>(
    'quilometros_percorridos',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    usuarioId,
    veiculoId,
    dataHoraInicio,
    dataHoraFim,
    odometroInicio,
    odometroFim,
    cidadeOrigem,
    cidadeDestino,
    status,
    odometroAlterado,
    observacoes,
    dataCriacao,
    dataAtualizacao,
    quilometrosPercorridos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'jornadas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Jornada> instance, {
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
    if (data.containsKey('veiculo_id')) {
      context.handle(
        _veiculoIdMeta,
        veiculoId.isAcceptableOrUnknown(data['veiculo_id']!, _veiculoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_veiculoIdMeta);
    }
    if (data.containsKey('data_hora_inicio')) {
      context.handle(
        _dataHoraInicioMeta,
        dataHoraInicio.isAcceptableOrUnknown(
          data['data_hora_inicio']!,
          _dataHoraInicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataHoraInicioMeta);
    }
    if (data.containsKey('data_hora_fim')) {
      context.handle(
        _dataHoraFimMeta,
        dataHoraFim.isAcceptableOrUnknown(
          data['data_hora_fim']!,
          _dataHoraFimMeta,
        ),
      );
    }
    if (data.containsKey('odometro_inicio')) {
      context.handle(
        _odometroInicioMeta,
        odometroInicio.isAcceptableOrUnknown(
          data['odometro_inicio']!,
          _odometroInicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_odometroInicioMeta);
    }
    if (data.containsKey('odometro_fim')) {
      context.handle(
        _odometroFimMeta,
        odometroFim.isAcceptableOrUnknown(
          data['odometro_fim']!,
          _odometroFimMeta,
        ),
      );
    }
    if (data.containsKey('cidade_origem')) {
      context.handle(
        _cidadeOrigemMeta,
        cidadeOrigem.isAcceptableOrUnknown(
          data['cidade_origem']!,
          _cidadeOrigemMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cidadeOrigemMeta);
    }
    if (data.containsKey('cidade_destino')) {
      context.handle(
        _cidadeDestinoMeta,
        cidadeDestino.isAcceptableOrUnknown(
          data['cidade_destino']!,
          _cidadeDestinoMeta,
        ),
      );
    }
    if (data.containsKey('odometro_alterado')) {
      context.handle(
        _odometroAlteradoMeta,
        odometroAlterado.isAcceptableOrUnknown(
          data['odometro_alterado']!,
          _odometroAlteradoMeta,
        ),
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
    if (data.containsKey('data_criacao')) {
      context.handle(
        _dataCriacaoMeta,
        dataCriacao.isAcceptableOrUnknown(
          data['data_criacao']!,
          _dataCriacaoMeta,
        ),
      );
    }
    if (data.containsKey('data_atualizacao')) {
      context.handle(
        _dataAtualizacaoMeta,
        dataAtualizacao.isAcceptableOrUnknown(
          data['data_atualizacao']!,
          _dataAtualizacaoMeta,
        ),
      );
    }
    if (data.containsKey('quilometros_percorridos')) {
      context.handle(
        _quilometrosPercorridosMeta,
        quilometrosPercorridos.isAcceptableOrUnknown(
          data['quilometros_percorridos']!,
          _quilometrosPercorridosMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Jornada map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Jornada(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      veiculoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}veiculo_id'],
      )!,
      dataHoraInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora_inicio'],
      )!,
      dataHoraFim: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora_fim'],
      ),
      odometroInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odometro_inicio'],
      )!,
      odometroFim: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odometro_fim'],
      ),
      cidadeOrigem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cidade_origem'],
      )!,
      cidadeDestino: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cidade_destino'],
      ),
      status: $JornadasTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      odometroAlterado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}odometro_alterado'],
      )!,
      observacoes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacoes'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      dataAtualizacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_atualizacao'],
      )!,
      quilometrosPercorridos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quilometros_percorridos'],
      ),
    );
  }

  @override
  $JornadasTable createAlias(String alias) {
    return $JornadasTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StatusJornada, String, String> $converterstatus =
      const EnumNameConverter<StatusJornada>(StatusJornada.values);
}

class Jornada extends DataClass implements Insertable<Jornada> {
  final int id;
  final int usuarioId;
  final int veiculoId;
  final DateTime dataHoraInicio;
  final DateTime? dataHoraFim;
  final int odometroInicio;
  final int? odometroFim;
  final String cidadeOrigem;
  final String? cidadeDestino;
  final StatusJornada status;
  final bool odometroAlterado;
  final String? observacoes;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;
  final int? quilometrosPercorridos;
  const Jornada({
    required this.id,
    required this.usuarioId,
    required this.veiculoId,
    required this.dataHoraInicio,
    this.dataHoraFim,
    required this.odometroInicio,
    this.odometroFim,
    required this.cidadeOrigem,
    this.cidadeDestino,
    required this.status,
    required this.odometroAlterado,
    this.observacoes,
    required this.dataCriacao,
    required this.dataAtualizacao,
    this.quilometrosPercorridos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['usuario_id'] = Variable<int>(usuarioId);
    map['veiculo_id'] = Variable<int>(veiculoId);
    map['data_hora_inicio'] = Variable<DateTime>(dataHoraInicio);
    if (!nullToAbsent || dataHoraFim != null) {
      map['data_hora_fim'] = Variable<DateTime>(dataHoraFim);
    }
    map['odometro_inicio'] = Variable<int>(odometroInicio);
    if (!nullToAbsent || odometroFim != null) {
      map['odometro_fim'] = Variable<int>(odometroFim);
    }
    map['cidade_origem'] = Variable<String>(cidadeOrigem);
    if (!nullToAbsent || cidadeDestino != null) {
      map['cidade_destino'] = Variable<String>(cidadeDestino);
    }
    {
      map['status'] = Variable<String>(
        $JornadasTable.$converterstatus.toSql(status),
      );
    }
    map['odometro_alterado'] = Variable<bool>(odometroAlterado);
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao);
    if (!nullToAbsent || quilometrosPercorridos != null) {
      map['quilometros_percorridos'] = Variable<int>(quilometrosPercorridos);
    }
    return map;
  }

  JornadasCompanion toCompanion(bool nullToAbsent) {
    return JornadasCompanion(
      id: Value(id),
      usuarioId: Value(usuarioId),
      veiculoId: Value(veiculoId),
      dataHoraInicio: Value(dataHoraInicio),
      dataHoraFim: dataHoraFim == null && nullToAbsent
          ? const Value.absent()
          : Value(dataHoraFim),
      odometroInicio: Value(odometroInicio),
      odometroFim: odometroFim == null && nullToAbsent
          ? const Value.absent()
          : Value(odometroFim),
      cidadeOrigem: Value(cidadeOrigem),
      cidadeDestino: cidadeDestino == null && nullToAbsent
          ? const Value.absent()
          : Value(cidadeDestino),
      status: Value(status),
      odometroAlterado: Value(odometroAlterado),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      dataCriacao: Value(dataCriacao),
      dataAtualizacao: Value(dataAtualizacao),
      quilometrosPercorridos: quilometrosPercorridos == null && nullToAbsent
          ? const Value.absent()
          : Value(quilometrosPercorridos),
    );
  }

  factory Jornada.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Jornada(
      id: serializer.fromJson<int>(json['id']),
      usuarioId: serializer.fromJson<int>(json['usuarioId']),
      veiculoId: serializer.fromJson<int>(json['veiculoId']),
      dataHoraInicio: serializer.fromJson<DateTime>(json['dataHoraInicio']),
      dataHoraFim: serializer.fromJson<DateTime?>(json['dataHoraFim']),
      odometroInicio: serializer.fromJson<int>(json['odometroInicio']),
      odometroFim: serializer.fromJson<int?>(json['odometroFim']),
      cidadeOrigem: serializer.fromJson<String>(json['cidadeOrigem']),
      cidadeDestino: serializer.fromJson<String?>(json['cidadeDestino']),
      status: $JornadasTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      odometroAlterado: serializer.fromJson<bool>(json['odometroAlterado']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      dataAtualizacao: serializer.fromJson<DateTime>(json['dataAtualizacao']),
      quilometrosPercorridos: serializer.fromJson<int?>(
        json['quilometrosPercorridos'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'usuarioId': serializer.toJson<int>(usuarioId),
      'veiculoId': serializer.toJson<int>(veiculoId),
      'dataHoraInicio': serializer.toJson<DateTime>(dataHoraInicio),
      'dataHoraFim': serializer.toJson<DateTime?>(dataHoraFim),
      'odometroInicio': serializer.toJson<int>(odometroInicio),
      'odometroFim': serializer.toJson<int?>(odometroFim),
      'cidadeOrigem': serializer.toJson<String>(cidadeOrigem),
      'cidadeDestino': serializer.toJson<String?>(cidadeDestino),
      'status': serializer.toJson<String>(
        $JornadasTable.$converterstatus.toJson(status),
      ),
      'odometroAlterado': serializer.toJson<bool>(odometroAlterado),
      'observacoes': serializer.toJson<String?>(observacoes),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'dataAtualizacao': serializer.toJson<DateTime>(dataAtualizacao),
      'quilometrosPercorridos': serializer.toJson<int?>(quilometrosPercorridos),
    };
  }

  Jornada copyWith({
    int? id,
    int? usuarioId,
    int? veiculoId,
    DateTime? dataHoraInicio,
    Value<DateTime?> dataHoraFim = const Value.absent(),
    int? odometroInicio,
    Value<int?> odometroFim = const Value.absent(),
    String? cidadeOrigem,
    Value<String?> cidadeDestino = const Value.absent(),
    StatusJornada? status,
    bool? odometroAlterado,
    Value<String?> observacoes = const Value.absent(),
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
    Value<int?> quilometrosPercorridos = const Value.absent(),
  }) => Jornada(
    id: id ?? this.id,
    usuarioId: usuarioId ?? this.usuarioId,
    veiculoId: veiculoId ?? this.veiculoId,
    dataHoraInicio: dataHoraInicio ?? this.dataHoraInicio,
    dataHoraFim: dataHoraFim.present ? dataHoraFim.value : this.dataHoraFim,
    odometroInicio: odometroInicio ?? this.odometroInicio,
    odometroFim: odometroFim.present ? odometroFim.value : this.odometroFim,
    cidadeOrigem: cidadeOrigem ?? this.cidadeOrigem,
    cidadeDestino: cidadeDestino.present
        ? cidadeDestino.value
        : this.cidadeDestino,
    status: status ?? this.status,
    odometroAlterado: odometroAlterado ?? this.odometroAlterado,
    observacoes: observacoes.present ? observacoes.value : this.observacoes,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    quilometrosPercorridos: quilometrosPercorridos.present
        ? quilometrosPercorridos.value
        : this.quilometrosPercorridos,
  );
  Jornada copyWithCompanion(JornadasCompanion data) {
    return Jornada(
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      veiculoId: data.veiculoId.present ? data.veiculoId.value : this.veiculoId,
      dataHoraInicio: data.dataHoraInicio.present
          ? data.dataHoraInicio.value
          : this.dataHoraInicio,
      dataHoraFim: data.dataHoraFim.present
          ? data.dataHoraFim.value
          : this.dataHoraFim,
      odometroInicio: data.odometroInicio.present
          ? data.odometroInicio.value
          : this.odometroInicio,
      odometroFim: data.odometroFim.present
          ? data.odometroFim.value
          : this.odometroFim,
      cidadeOrigem: data.cidadeOrigem.present
          ? data.cidadeOrigem.value
          : this.cidadeOrigem,
      cidadeDestino: data.cidadeDestino.present
          ? data.cidadeDestino.value
          : this.cidadeDestino,
      status: data.status.present ? data.status.value : this.status,
      odometroAlterado: data.odometroAlterado.present
          ? data.odometroAlterado.value
          : this.odometroAlterado,
      observacoes: data.observacoes.present
          ? data.observacoes.value
          : this.observacoes,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      dataAtualizacao: data.dataAtualizacao.present
          ? data.dataAtualizacao.value
          : this.dataAtualizacao,
      quilometrosPercorridos: data.quilometrosPercorridos.present
          ? data.quilometrosPercorridos.value
          : this.quilometrosPercorridos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Jornada(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('dataHoraInicio: $dataHoraInicio, ')
          ..write('dataHoraFim: $dataHoraFim, ')
          ..write('odometroInicio: $odometroInicio, ')
          ..write('odometroFim: $odometroFim, ')
          ..write('cidadeOrigem: $cidadeOrigem, ')
          ..write('cidadeDestino: $cidadeDestino, ')
          ..write('status: $status, ')
          ..write('odometroAlterado: $odometroAlterado, ')
          ..write('observacoes: $observacoes, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao, ')
          ..write('quilometrosPercorridos: $quilometrosPercorridos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    usuarioId,
    veiculoId,
    dataHoraInicio,
    dataHoraFim,
    odometroInicio,
    odometroFim,
    cidadeOrigem,
    cidadeDestino,
    status,
    odometroAlterado,
    observacoes,
    dataCriacao,
    dataAtualizacao,
    quilometrosPercorridos,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Jornada &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.veiculoId == this.veiculoId &&
          other.dataHoraInicio == this.dataHoraInicio &&
          other.dataHoraFim == this.dataHoraFim &&
          other.odometroInicio == this.odometroInicio &&
          other.odometroFim == this.odometroFim &&
          other.cidadeOrigem == this.cidadeOrigem &&
          other.cidadeDestino == this.cidadeDestino &&
          other.status == this.status &&
          other.odometroAlterado == this.odometroAlterado &&
          other.observacoes == this.observacoes &&
          other.dataCriacao == this.dataCriacao &&
          other.dataAtualizacao == this.dataAtualizacao &&
          other.quilometrosPercorridos == this.quilometrosPercorridos);
}

class JornadasCompanion extends UpdateCompanion<Jornada> {
  final Value<int> id;
  final Value<int> usuarioId;
  final Value<int> veiculoId;
  final Value<DateTime> dataHoraInicio;
  final Value<DateTime?> dataHoraFim;
  final Value<int> odometroInicio;
  final Value<int?> odometroFim;
  final Value<String> cidadeOrigem;
  final Value<String?> cidadeDestino;
  final Value<StatusJornada> status;
  final Value<bool> odometroAlterado;
  final Value<String?> observacoes;
  final Value<DateTime> dataCriacao;
  final Value<DateTime> dataAtualizacao;
  final Value<int?> quilometrosPercorridos;
  const JornadasCompanion({
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.veiculoId = const Value.absent(),
    this.dataHoraInicio = const Value.absent(),
    this.dataHoraFim = const Value.absent(),
    this.odometroInicio = const Value.absent(),
    this.odometroFim = const Value.absent(),
    this.cidadeOrigem = const Value.absent(),
    this.cidadeDestino = const Value.absent(),
    this.status = const Value.absent(),
    this.odometroAlterado = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
    this.quilometrosPercorridos = const Value.absent(),
  });
  JornadasCompanion.insert({
    this.id = const Value.absent(),
    required int usuarioId,
    required int veiculoId,
    required DateTime dataHoraInicio,
    this.dataHoraFim = const Value.absent(),
    required int odometroInicio,
    this.odometroFim = const Value.absent(),
    required String cidadeOrigem,
    this.cidadeDestino = const Value.absent(),
    required StatusJornada status,
    this.odometroAlterado = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
    this.quilometrosPercorridos = const Value.absent(),
  }) : usuarioId = Value(usuarioId),
       veiculoId = Value(veiculoId),
       dataHoraInicio = Value(dataHoraInicio),
       odometroInicio = Value(odometroInicio),
       cidadeOrigem = Value(cidadeOrigem),
       status = Value(status);
  static Insertable<Jornada> custom({
    Expression<int>? id,
    Expression<int>? usuarioId,
    Expression<int>? veiculoId,
    Expression<DateTime>? dataHoraInicio,
    Expression<DateTime>? dataHoraFim,
    Expression<int>? odometroInicio,
    Expression<int>? odometroFim,
    Expression<String>? cidadeOrigem,
    Expression<String>? cidadeDestino,
    Expression<String>? status,
    Expression<bool>? odometroAlterado,
    Expression<String>? observacoes,
    Expression<DateTime>? dataCriacao,
    Expression<DateTime>? dataAtualizacao,
    Expression<int>? quilometrosPercorridos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (veiculoId != null) 'veiculo_id': veiculoId,
      if (dataHoraInicio != null) 'data_hora_inicio': dataHoraInicio,
      if (dataHoraFim != null) 'data_hora_fim': dataHoraFim,
      if (odometroInicio != null) 'odometro_inicio': odometroInicio,
      if (odometroFim != null) 'odometro_fim': odometroFim,
      if (cidadeOrigem != null) 'cidade_origem': cidadeOrigem,
      if (cidadeDestino != null) 'cidade_destino': cidadeDestino,
      if (status != null) 'status': status,
      if (odometroAlterado != null) 'odometro_alterado': odometroAlterado,
      if (observacoes != null) 'observacoes': observacoes,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (dataAtualizacao != null) 'data_atualizacao': dataAtualizacao,
      if (quilometrosPercorridos != null)
        'quilometros_percorridos': quilometrosPercorridos,
    });
  }

  JornadasCompanion copyWith({
    Value<int>? id,
    Value<int>? usuarioId,
    Value<int>? veiculoId,
    Value<DateTime>? dataHoraInicio,
    Value<DateTime?>? dataHoraFim,
    Value<int>? odometroInicio,
    Value<int?>? odometroFim,
    Value<String>? cidadeOrigem,
    Value<String?>? cidadeDestino,
    Value<StatusJornada>? status,
    Value<bool>? odometroAlterado,
    Value<String?>? observacoes,
    Value<DateTime>? dataCriacao,
    Value<DateTime>? dataAtualizacao,
    Value<int?>? quilometrosPercorridos,
  }) {
    return JornadasCompanion(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      veiculoId: veiculoId ?? this.veiculoId,
      dataHoraInicio: dataHoraInicio ?? this.dataHoraInicio,
      dataHoraFim: dataHoraFim ?? this.dataHoraFim,
      odometroInicio: odometroInicio ?? this.odometroInicio,
      odometroFim: odometroFim ?? this.odometroFim,
      cidadeOrigem: cidadeOrigem ?? this.cidadeOrigem,
      cidadeDestino: cidadeDestino ?? this.cidadeDestino,
      status: status ?? this.status,
      odometroAlterado: odometroAlterado ?? this.odometroAlterado,
      observacoes: observacoes ?? this.observacoes,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      quilometrosPercorridos:
          quilometrosPercorridos ?? this.quilometrosPercorridos,
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
    if (veiculoId.present) {
      map['veiculo_id'] = Variable<int>(veiculoId.value);
    }
    if (dataHoraInicio.present) {
      map['data_hora_inicio'] = Variable<DateTime>(dataHoraInicio.value);
    }
    if (dataHoraFim.present) {
      map['data_hora_fim'] = Variable<DateTime>(dataHoraFim.value);
    }
    if (odometroInicio.present) {
      map['odometro_inicio'] = Variable<int>(odometroInicio.value);
    }
    if (odometroFim.present) {
      map['odometro_fim'] = Variable<int>(odometroFim.value);
    }
    if (cidadeOrigem.present) {
      map['cidade_origem'] = Variable<String>(cidadeOrigem.value);
    }
    if (cidadeDestino.present) {
      map['cidade_destino'] = Variable<String>(cidadeDestino.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $JornadasTable.$converterstatus.toSql(status.value),
      );
    }
    if (odometroAlterado.present) {
      map['odometro_alterado'] = Variable<bool>(odometroAlterado.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (dataAtualizacao.present) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao.value);
    }
    if (quilometrosPercorridos.present) {
      map['quilometros_percorridos'] = Variable<int>(
        quilometrosPercorridos.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JornadasCompanion(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('dataHoraInicio: $dataHoraInicio, ')
          ..write('dataHoraFim: $dataHoraFim, ')
          ..write('odometroInicio: $odometroInicio, ')
          ..write('odometroFim: $odometroFim, ')
          ..write('cidadeOrigem: $cidadeOrigem, ')
          ..write('cidadeDestino: $cidadeDestino, ')
          ..write('status: $status, ')
          ..write('odometroAlterado: $odometroAlterado, ')
          ..write('observacoes: $observacoes, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao, ')
          ..write('quilometrosPercorridos: $quilometrosPercorridos')
          ..write(')'))
        .toString();
  }
}

class $PausasTable extends Pausas with TableInfo<$PausasTable, Pausa> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PausasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _jornadaIdMeta = const VerificationMeta(
    'jornadaId',
  );
  @override
  late final GeneratedColumn<int> jornadaId = GeneratedColumn<int>(
    'jornada_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jornadas (id)',
    ),
  );
  static const VerificationMeta _inicioMeta = const VerificationMeta('inicio');
  @override
  late final GeneratedColumn<DateTime> inicio = GeneratedColumn<DateTime>(
    'inicio',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fimMeta = const VerificationMeta('fim');
  @override
  late final GeneratedColumn<DateTime> fim = GeneratedColumn<DateTime>(
    'fim',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _motivoMeta = const VerificationMeta('motivo');
  @override
  late final GeneratedColumn<String> motivo = GeneratedColumn<String>(
    'motivo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _observacaoMeta = const VerificationMeta(
    'observacao',
  );
  @override
  late final GeneratedColumn<String> observacao = GeneratedColumn<String>(
    'observacao',
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
  static const VerificationMeta _registrarGanhosMeta = const VerificationMeta(
    'registrarGanhos',
  );
  @override
  late final GeneratedColumn<bool> registrarGanhos = GeneratedColumn<bool>(
    'registrar_ganhos',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("registrar_ganhos" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _concluidaMeta = const VerificationMeta(
    'concluida',
  );
  @override
  late final GeneratedColumn<bool> concluida = GeneratedColumn<bool>(
    'concluida',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("concluida" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jornadaId,
    inicio,
    fim,
    motivo,
    observacao,
    dataCriacao,
    registrarGanhos,
    concluida,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pausas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pausa> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('jornada_id')) {
      context.handle(
        _jornadaIdMeta,
        jornadaId.isAcceptableOrUnknown(data['jornada_id']!, _jornadaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_jornadaIdMeta);
    }
    if (data.containsKey('inicio')) {
      context.handle(
        _inicioMeta,
        inicio.isAcceptableOrUnknown(data['inicio']!, _inicioMeta),
      );
    } else if (isInserting) {
      context.missing(_inicioMeta);
    }
    if (data.containsKey('fim')) {
      context.handle(
        _fimMeta,
        fim.isAcceptableOrUnknown(data['fim']!, _fimMeta),
      );
    }
    if (data.containsKey('motivo')) {
      context.handle(
        _motivoMeta,
        motivo.isAcceptableOrUnknown(data['motivo']!, _motivoMeta),
      );
    }
    if (data.containsKey('observacao')) {
      context.handle(
        _observacaoMeta,
        observacao.isAcceptableOrUnknown(data['observacao']!, _observacaoMeta),
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
    if (data.containsKey('registrar_ganhos')) {
      context.handle(
        _registrarGanhosMeta,
        registrarGanhos.isAcceptableOrUnknown(
          data['registrar_ganhos']!,
          _registrarGanhosMeta,
        ),
      );
    }
    if (data.containsKey('concluida')) {
      context.handle(
        _concluidaMeta,
        concluida.isAcceptableOrUnknown(data['concluida']!, _concluidaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pausa map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pausa(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      jornadaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jornada_id'],
      )!,
      inicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}inicio'],
      )!,
      fim: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fim'],
      ),
      motivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivo'],
      ),
      observacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacao'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      registrarGanhos: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}registrar_ganhos'],
      )!,
      concluida: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}concluida'],
      )!,
    );
  }

  @override
  $PausasTable createAlias(String alias) {
    return $PausasTable(attachedDatabase, alias);
  }
}

class Pausa extends DataClass implements Insertable<Pausa> {
  final int id;
  final int jornadaId;
  final DateTime inicio;
  final DateTime? fim;
  final String? motivo;
  final String? observacao;
  final DateTime dataCriacao;
  final bool registrarGanhos;
  final bool concluida;
  const Pausa({
    required this.id,
    required this.jornadaId,
    required this.inicio,
    this.fim,
    this.motivo,
    this.observacao,
    required this.dataCriacao,
    required this.registrarGanhos,
    required this.concluida,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['jornada_id'] = Variable<int>(jornadaId);
    map['inicio'] = Variable<DateTime>(inicio);
    if (!nullToAbsent || fim != null) {
      map['fim'] = Variable<DateTime>(fim);
    }
    if (!nullToAbsent || motivo != null) {
      map['motivo'] = Variable<String>(motivo);
    }
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    map['registrar_ganhos'] = Variable<bool>(registrarGanhos);
    map['concluida'] = Variable<bool>(concluida);
    return map;
  }

  PausasCompanion toCompanion(bool nullToAbsent) {
    return PausasCompanion(
      id: Value(id),
      jornadaId: Value(jornadaId),
      inicio: Value(inicio),
      fim: fim == null && nullToAbsent ? const Value.absent() : Value(fim),
      motivo: motivo == null && nullToAbsent
          ? const Value.absent()
          : Value(motivo),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
      dataCriacao: Value(dataCriacao),
      registrarGanhos: Value(registrarGanhos),
      concluida: Value(concluida),
    );
  }

  factory Pausa.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pausa(
      id: serializer.fromJson<int>(json['id']),
      jornadaId: serializer.fromJson<int>(json['jornadaId']),
      inicio: serializer.fromJson<DateTime>(json['inicio']),
      fim: serializer.fromJson<DateTime?>(json['fim']),
      motivo: serializer.fromJson<String?>(json['motivo']),
      observacao: serializer.fromJson<String?>(json['observacao']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      registrarGanhos: serializer.fromJson<bool>(json['registrarGanhos']),
      concluida: serializer.fromJson<bool>(json['concluida']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'jornadaId': serializer.toJson<int>(jornadaId),
      'inicio': serializer.toJson<DateTime>(inicio),
      'fim': serializer.toJson<DateTime?>(fim),
      'motivo': serializer.toJson<String?>(motivo),
      'observacao': serializer.toJson<String?>(observacao),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'registrarGanhos': serializer.toJson<bool>(registrarGanhos),
      'concluida': serializer.toJson<bool>(concluida),
    };
  }

  Pausa copyWith({
    int? id,
    int? jornadaId,
    DateTime? inicio,
    Value<DateTime?> fim = const Value.absent(),
    Value<String?> motivo = const Value.absent(),
    Value<String?> observacao = const Value.absent(),
    DateTime? dataCriacao,
    bool? registrarGanhos,
    bool? concluida,
  }) => Pausa(
    id: id ?? this.id,
    jornadaId: jornadaId ?? this.jornadaId,
    inicio: inicio ?? this.inicio,
    fim: fim.present ? fim.value : this.fim,
    motivo: motivo.present ? motivo.value : this.motivo,
    observacao: observacao.present ? observacao.value : this.observacao,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    registrarGanhos: registrarGanhos ?? this.registrarGanhos,
    concluida: concluida ?? this.concluida,
  );
  Pausa copyWithCompanion(PausasCompanion data) {
    return Pausa(
      id: data.id.present ? data.id.value : this.id,
      jornadaId: data.jornadaId.present ? data.jornadaId.value : this.jornadaId,
      inicio: data.inicio.present ? data.inicio.value : this.inicio,
      fim: data.fim.present ? data.fim.value : this.fim,
      motivo: data.motivo.present ? data.motivo.value : this.motivo,
      observacao: data.observacao.present
          ? data.observacao.value
          : this.observacao,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      registrarGanhos: data.registrarGanhos.present
          ? data.registrarGanhos.value
          : this.registrarGanhos,
      concluida: data.concluida.present ? data.concluida.value : this.concluida,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pausa(')
          ..write('id: $id, ')
          ..write('jornadaId: $jornadaId, ')
          ..write('inicio: $inicio, ')
          ..write('fim: $fim, ')
          ..write('motivo: $motivo, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('registrarGanhos: $registrarGanhos, ')
          ..write('concluida: $concluida')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jornadaId,
    inicio,
    fim,
    motivo,
    observacao,
    dataCriacao,
    registrarGanhos,
    concluida,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pausa &&
          other.id == this.id &&
          other.jornadaId == this.jornadaId &&
          other.inicio == this.inicio &&
          other.fim == this.fim &&
          other.motivo == this.motivo &&
          other.observacao == this.observacao &&
          other.dataCriacao == this.dataCriacao &&
          other.registrarGanhos == this.registrarGanhos &&
          other.concluida == this.concluida);
}

class PausasCompanion extends UpdateCompanion<Pausa> {
  final Value<int> id;
  final Value<int> jornadaId;
  final Value<DateTime> inicio;
  final Value<DateTime?> fim;
  final Value<String?> motivo;
  final Value<String?> observacao;
  final Value<DateTime> dataCriacao;
  final Value<bool> registrarGanhos;
  final Value<bool> concluida;
  const PausasCompanion({
    this.id = const Value.absent(),
    this.jornadaId = const Value.absent(),
    this.inicio = const Value.absent(),
    this.fim = const Value.absent(),
    this.motivo = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.registrarGanhos = const Value.absent(),
    this.concluida = const Value.absent(),
  });
  PausasCompanion.insert({
    this.id = const Value.absent(),
    required int jornadaId,
    required DateTime inicio,
    this.fim = const Value.absent(),
    this.motivo = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.registrarGanhos = const Value.absent(),
    this.concluida = const Value.absent(),
  }) : jornadaId = Value(jornadaId),
       inicio = Value(inicio);
  static Insertable<Pausa> custom({
    Expression<int>? id,
    Expression<int>? jornadaId,
    Expression<DateTime>? inicio,
    Expression<DateTime>? fim,
    Expression<String>? motivo,
    Expression<String>? observacao,
    Expression<DateTime>? dataCriacao,
    Expression<bool>? registrarGanhos,
    Expression<bool>? concluida,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jornadaId != null) 'jornada_id': jornadaId,
      if (inicio != null) 'inicio': inicio,
      if (fim != null) 'fim': fim,
      if (motivo != null) 'motivo': motivo,
      if (observacao != null) 'observacao': observacao,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (registrarGanhos != null) 'registrar_ganhos': registrarGanhos,
      if (concluida != null) 'concluida': concluida,
    });
  }

  PausasCompanion copyWith({
    Value<int>? id,
    Value<int>? jornadaId,
    Value<DateTime>? inicio,
    Value<DateTime?>? fim,
    Value<String?>? motivo,
    Value<String?>? observacao,
    Value<DateTime>? dataCriacao,
    Value<bool>? registrarGanhos,
    Value<bool>? concluida,
  }) {
    return PausasCompanion(
      id: id ?? this.id,
      jornadaId: jornadaId ?? this.jornadaId,
      inicio: inicio ?? this.inicio,
      fim: fim ?? this.fim,
      motivo: motivo ?? this.motivo,
      observacao: observacao ?? this.observacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      registrarGanhos: registrarGanhos ?? this.registrarGanhos,
      concluida: concluida ?? this.concluida,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (jornadaId.present) {
      map['jornada_id'] = Variable<int>(jornadaId.value);
    }
    if (inicio.present) {
      map['inicio'] = Variable<DateTime>(inicio.value);
    }
    if (fim.present) {
      map['fim'] = Variable<DateTime>(fim.value);
    }
    if (motivo.present) {
      map['motivo'] = Variable<String>(motivo.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (registrarGanhos.present) {
      map['registrar_ganhos'] = Variable<bool>(registrarGanhos.value);
    }
    if (concluida.present) {
      map['concluida'] = Variable<bool>(concluida.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PausasCompanion(')
          ..write('id: $id, ')
          ..write('jornadaId: $jornadaId, ')
          ..write('inicio: $inicio, ')
          ..write('fim: $fim, ')
          ..write('motivo: $motivo, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('registrarGanhos: $registrarGanhos, ')
          ..write('concluida: $concluida')
          ..write(')'))
        .toString();
  }
}

class $PlataformasTable extends Plataformas
    with TableInfo<$PlataformasTable, Plataforma> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlataformasTable(this.attachedDatabase, [this._alias]);
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconeMeta = const VerificationMeta('icone');
  @override
  late final GeneratedColumn<String> icone = GeneratedColumn<String>(
    'icone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _corMeta = const VerificationMeta('cor');
  @override
  late final GeneratedColumn<String> cor = GeneratedColumn<String>(
    'cor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ativaMeta = const VerificationMeta('ativa');
  @override
  late final GeneratedColumn<bool> ativa = GeneratedColumn<bool>(
    'ativa',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativa" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
    'ordem',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    icone,
    cor,
    ativa,
    ordem,
    dataCriacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plataformas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Plataforma> instance, {
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
    if (data.containsKey('icone')) {
      context.handle(
        _iconeMeta,
        icone.isAcceptableOrUnknown(data['icone']!, _iconeMeta),
      );
    }
    if (data.containsKey('cor')) {
      context.handle(
        _corMeta,
        cor.isAcceptableOrUnknown(data['cor']!, _corMeta),
      );
    }
    if (data.containsKey('ativa')) {
      context.handle(
        _ativaMeta,
        ativa.isAcceptableOrUnknown(data['ativa']!, _ativaMeta),
      );
    }
    if (data.containsKey('ordem')) {
      context.handle(
        _ordemMeta,
        ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Plataforma map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Plataforma(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      icone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icone'],
      ),
      cor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cor'],
      ),
      ativa: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativa'],
      )!,
      ordem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem'],
      )!,
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
    );
  }

  @override
  $PlataformasTable createAlias(String alias) {
    return $PlataformasTable(attachedDatabase, alias);
  }
}

class Plataforma extends DataClass implements Insertable<Plataforma> {
  final int id;
  final String nome;
  final String? icone;
  final String? cor;
  final bool ativa;
  final int ordem;
  final DateTime dataCriacao;
  const Plataforma({
    required this.id,
    required this.nome,
    this.icone,
    this.cor,
    required this.ativa,
    required this.ordem,
    required this.dataCriacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || icone != null) {
      map['icone'] = Variable<String>(icone);
    }
    if (!nullToAbsent || cor != null) {
      map['cor'] = Variable<String>(cor);
    }
    map['ativa'] = Variable<bool>(ativa);
    map['ordem'] = Variable<int>(ordem);
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    return map;
  }

  PlataformasCompanion toCompanion(bool nullToAbsent) {
    return PlataformasCompanion(
      id: Value(id),
      nome: Value(nome),
      icone: icone == null && nullToAbsent
          ? const Value.absent()
          : Value(icone),
      cor: cor == null && nullToAbsent ? const Value.absent() : Value(cor),
      ativa: Value(ativa),
      ordem: Value(ordem),
      dataCriacao: Value(dataCriacao),
    );
  }

  factory Plataforma.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Plataforma(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      icone: serializer.fromJson<String?>(json['icone']),
      cor: serializer.fromJson<String?>(json['cor']),
      ativa: serializer.fromJson<bool>(json['ativa']),
      ordem: serializer.fromJson<int>(json['ordem']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'icone': serializer.toJson<String?>(icone),
      'cor': serializer.toJson<String?>(cor),
      'ativa': serializer.toJson<bool>(ativa),
      'ordem': serializer.toJson<int>(ordem),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
    };
  }

  Plataforma copyWith({
    int? id,
    String? nome,
    Value<String?> icone = const Value.absent(),
    Value<String?> cor = const Value.absent(),
    bool? ativa,
    int? ordem,
    DateTime? dataCriacao,
  }) => Plataforma(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    icone: icone.present ? icone.value : this.icone,
    cor: cor.present ? cor.value : this.cor,
    ativa: ativa ?? this.ativa,
    ordem: ordem ?? this.ordem,
    dataCriacao: dataCriacao ?? this.dataCriacao,
  );
  Plataforma copyWithCompanion(PlataformasCompanion data) {
    return Plataforma(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      icone: data.icone.present ? data.icone.value : this.icone,
      cor: data.cor.present ? data.cor.value : this.cor,
      ativa: data.ativa.present ? data.ativa.value : this.ativa,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Plataforma(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('icone: $icone, ')
          ..write('cor: $cor, ')
          ..write('ativa: $ativa, ')
          ..write('ordem: $ordem, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nome, icone, cor, ativa, ordem, dataCriacao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plataforma &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.icone == this.icone &&
          other.cor == this.cor &&
          other.ativa == this.ativa &&
          other.ordem == this.ordem &&
          other.dataCriacao == this.dataCriacao);
}

class PlataformasCompanion extends UpdateCompanion<Plataforma> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String?> icone;
  final Value<String?> cor;
  final Value<bool> ativa;
  final Value<int> ordem;
  final Value<DateTime> dataCriacao;
  const PlataformasCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.icone = const Value.absent(),
    this.cor = const Value.absent(),
    this.ativa = const Value.absent(),
    this.ordem = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  });
  PlataformasCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.icone = const Value.absent(),
    this.cor = const Value.absent(),
    this.ativa = const Value.absent(),
    this.ordem = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  }) : nome = Value(nome);
  static Insertable<Plataforma> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? icone,
    Expression<String>? cor,
    Expression<bool>? ativa,
    Expression<int>? ordem,
    Expression<DateTime>? dataCriacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (icone != null) 'icone': icone,
      if (cor != null) 'cor': cor,
      if (ativa != null) 'ativa': ativa,
      if (ordem != null) 'ordem': ordem,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
    });
  }

  PlataformasCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String?>? icone,
    Value<String?>? cor,
    Value<bool>? ativa,
    Value<int>? ordem,
    Value<DateTime>? dataCriacao,
  }) {
    return PlataformasCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      icone: icone ?? this.icone,
      cor: cor ?? this.cor,
      ativa: ativa ?? this.ativa,
      ordem: ordem ?? this.ordem,
      dataCriacao: dataCriacao ?? this.dataCriacao,
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
    if (icone.present) {
      map['icone'] = Variable<String>(icone.value);
    }
    if (cor.present) {
      map['cor'] = Variable<String>(cor.value);
    }
    if (ativa.present) {
      map['ativa'] = Variable<bool>(ativa.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlataformasCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('icone: $icone, ')
          ..write('cor: $cor, ')
          ..write('ativa: $ativa, ')
          ..write('ordem: $ordem, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }
}

class $GanhosTable extends Ganhos with TableInfo<$GanhosTable, Ganho> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GanhosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _pausaIdMeta = const VerificationMeta(
    'pausaId',
  );
  @override
  late final GeneratedColumn<int> pausaId = GeneratedColumn<int>(
    'pausa_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pausas (id)',
    ),
  );
  static const VerificationMeta _plataformaIdMeta = const VerificationMeta(
    'plataformaId',
  );
  @override
  late final GeneratedColumn<int> plataformaId = GeneratedColumn<int>(
    'plataforma_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plataformas (id)',
    ),
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantidadeCorridasMeta =
      const VerificationMeta('quantidadeCorridas');
  @override
  late final GeneratedColumn<int> quantidadeCorridas = GeneratedColumn<int>(
    'quantidade_corridas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _registroFinalMeta = const VerificationMeta(
    'registroFinal',
  );
  @override
  late final GeneratedColumn<bool> registroFinal = GeneratedColumn<bool>(
    'registro_final',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("registro_final" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pausaId,
    plataformaId,
    valor,
    quantidadeCorridas,
    registroFinal,
    dataCriacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ganhos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ganho> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pausa_id')) {
      context.handle(
        _pausaIdMeta,
        pausaId.isAcceptableOrUnknown(data['pausa_id']!, _pausaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pausaIdMeta);
    }
    if (data.containsKey('plataforma_id')) {
      context.handle(
        _plataformaIdMeta,
        plataformaId.isAcceptableOrUnknown(
          data['plataforma_id']!,
          _plataformaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plataformaIdMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('quantidade_corridas')) {
      context.handle(
        _quantidadeCorridasMeta,
        quantidadeCorridas.isAcceptableOrUnknown(
          data['quantidade_corridas']!,
          _quantidadeCorridasMeta,
        ),
      );
    }
    if (data.containsKey('registro_final')) {
      context.handle(
        _registroFinalMeta,
        registroFinal.isAcceptableOrUnknown(
          data['registro_final']!,
          _registroFinalMeta,
        ),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ganho map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ganho(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pausaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pausa_id'],
      )!,
      plataformaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plataforma_id'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor'],
      )!,
      quantidadeCorridas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantidade_corridas'],
      )!,
      registroFinal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}registro_final'],
      )!,
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
    );
  }

  @override
  $GanhosTable createAlias(String alias) {
    return $GanhosTable(attachedDatabase, alias);
  }
}

class Ganho extends DataClass implements Insertable<Ganho> {
  final int id;
  final int pausaId;
  final int plataformaId;
  final double valor;
  final int quantidadeCorridas;
  final bool registroFinal;
  final DateTime dataCriacao;
  const Ganho({
    required this.id,
    required this.pausaId,
    required this.plataformaId,
    required this.valor,
    required this.quantidadeCorridas,
    required this.registroFinal,
    required this.dataCriacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pausa_id'] = Variable<int>(pausaId);
    map['plataforma_id'] = Variable<int>(plataformaId);
    map['valor'] = Variable<double>(valor);
    map['quantidade_corridas'] = Variable<int>(quantidadeCorridas);
    map['registro_final'] = Variable<bool>(registroFinal);
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    return map;
  }

  GanhosCompanion toCompanion(bool nullToAbsent) {
    return GanhosCompanion(
      id: Value(id),
      pausaId: Value(pausaId),
      plataformaId: Value(plataformaId),
      valor: Value(valor),
      quantidadeCorridas: Value(quantidadeCorridas),
      registroFinal: Value(registroFinal),
      dataCriacao: Value(dataCriacao),
    );
  }

  factory Ganho.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ganho(
      id: serializer.fromJson<int>(json['id']),
      pausaId: serializer.fromJson<int>(json['pausaId']),
      plataformaId: serializer.fromJson<int>(json['plataformaId']),
      valor: serializer.fromJson<double>(json['valor']),
      quantidadeCorridas: serializer.fromJson<int>(json['quantidadeCorridas']),
      registroFinal: serializer.fromJson<bool>(json['registroFinal']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pausaId': serializer.toJson<int>(pausaId),
      'plataformaId': serializer.toJson<int>(plataformaId),
      'valor': serializer.toJson<double>(valor),
      'quantidadeCorridas': serializer.toJson<int>(quantidadeCorridas),
      'registroFinal': serializer.toJson<bool>(registroFinal),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
    };
  }

  Ganho copyWith({
    int? id,
    int? pausaId,
    int? plataformaId,
    double? valor,
    int? quantidadeCorridas,
    bool? registroFinal,
    DateTime? dataCriacao,
  }) => Ganho(
    id: id ?? this.id,
    pausaId: pausaId ?? this.pausaId,
    plataformaId: plataformaId ?? this.plataformaId,
    valor: valor ?? this.valor,
    quantidadeCorridas: quantidadeCorridas ?? this.quantidadeCorridas,
    registroFinal: registroFinal ?? this.registroFinal,
    dataCriacao: dataCriacao ?? this.dataCriacao,
  );
  Ganho copyWithCompanion(GanhosCompanion data) {
    return Ganho(
      id: data.id.present ? data.id.value : this.id,
      pausaId: data.pausaId.present ? data.pausaId.value : this.pausaId,
      plataformaId: data.plataformaId.present
          ? data.plataformaId.value
          : this.plataformaId,
      valor: data.valor.present ? data.valor.value : this.valor,
      quantidadeCorridas: data.quantidadeCorridas.present
          ? data.quantidadeCorridas.value
          : this.quantidadeCorridas,
      registroFinal: data.registroFinal.present
          ? data.registroFinal.value
          : this.registroFinal,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ganho(')
          ..write('id: $id, ')
          ..write('pausaId: $pausaId, ')
          ..write('plataformaId: $plataformaId, ')
          ..write('valor: $valor, ')
          ..write('quantidadeCorridas: $quantidadeCorridas, ')
          ..write('registroFinal: $registroFinal, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pausaId,
    plataformaId,
    valor,
    quantidadeCorridas,
    registroFinal,
    dataCriacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ganho &&
          other.id == this.id &&
          other.pausaId == this.pausaId &&
          other.plataformaId == this.plataformaId &&
          other.valor == this.valor &&
          other.quantidadeCorridas == this.quantidadeCorridas &&
          other.registroFinal == this.registroFinal &&
          other.dataCriacao == this.dataCriacao);
}

class GanhosCompanion extends UpdateCompanion<Ganho> {
  final Value<int> id;
  final Value<int> pausaId;
  final Value<int> plataformaId;
  final Value<double> valor;
  final Value<int> quantidadeCorridas;
  final Value<bool> registroFinal;
  final Value<DateTime> dataCriacao;
  const GanhosCompanion({
    this.id = const Value.absent(),
    this.pausaId = const Value.absent(),
    this.plataformaId = const Value.absent(),
    this.valor = const Value.absent(),
    this.quantidadeCorridas = const Value.absent(),
    this.registroFinal = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  });
  GanhosCompanion.insert({
    this.id = const Value.absent(),
    required int pausaId,
    required int plataformaId,
    required double valor,
    this.quantidadeCorridas = const Value.absent(),
    this.registroFinal = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  }) : pausaId = Value(pausaId),
       plataformaId = Value(plataformaId),
       valor = Value(valor);
  static Insertable<Ganho> custom({
    Expression<int>? id,
    Expression<int>? pausaId,
    Expression<int>? plataformaId,
    Expression<double>? valor,
    Expression<int>? quantidadeCorridas,
    Expression<bool>? registroFinal,
    Expression<DateTime>? dataCriacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pausaId != null) 'pausa_id': pausaId,
      if (plataformaId != null) 'plataforma_id': plataformaId,
      if (valor != null) 'valor': valor,
      if (quantidadeCorridas != null) 'quantidade_corridas': quantidadeCorridas,
      if (registroFinal != null) 'registro_final': registroFinal,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
    });
  }

  GanhosCompanion copyWith({
    Value<int>? id,
    Value<int>? pausaId,
    Value<int>? plataformaId,
    Value<double>? valor,
    Value<int>? quantidadeCorridas,
    Value<bool>? registroFinal,
    Value<DateTime>? dataCriacao,
  }) {
    return GanhosCompanion(
      id: id ?? this.id,
      pausaId: pausaId ?? this.pausaId,
      plataformaId: plataformaId ?? this.plataformaId,
      valor: valor ?? this.valor,
      quantidadeCorridas: quantidadeCorridas ?? this.quantidadeCorridas,
      registroFinal: registroFinal ?? this.registroFinal,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pausaId.present) {
      map['pausa_id'] = Variable<int>(pausaId.value);
    }
    if (plataformaId.present) {
      map['plataforma_id'] = Variable<int>(plataformaId.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    if (quantidadeCorridas.present) {
      map['quantidade_corridas'] = Variable<int>(quantidadeCorridas.value);
    }
    if (registroFinal.present) {
      map['registro_final'] = Variable<bool>(registroFinal.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GanhosCompanion(')
          ..write('id: $id, ')
          ..write('pausaId: $pausaId, ')
          ..write('plataformaId: $plataformaId, ')
          ..write('valor: $valor, ')
          ..write('quantidadeCorridas: $quantidadeCorridas, ')
          ..write('registroFinal: $registroFinal, ')
          ..write('dataCriacao: $dataCriacao')
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
  late final $JornadasTable jornadas = $JornadasTable(this);
  late final $PausasTable pausas = $PausasTable(this);
  late final $PlataformasTable plataformas = $PlataformasTable(this);
  late final $GanhosTable ganhos = $GanhosTable(this);
  late final JornadaDao jornadaDao = JornadaDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    usuarios,
    veiculos,
    configuracoes,
    jornadas,
    pausas,
    plataformas,
    ganhos,
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

final class $$UsuariosTableReferences
    extends BaseReferences<_$AppDatabase, $UsuariosTable, Usuario> {
  $$UsuariosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$JornadasTable, List<Jornada>> _jornadasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.jornadas,
    aliasName: 'usuarios__id__jornadas__usuario_id',
  );

  $$JornadasTableProcessedTableManager get jornadasRefs {
    final manager = $$JornadasTableTableManager(
      $_db,
      $_db.jornadas,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_jornadasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  Expression<bool> jornadasRefs(
    Expression<bool> Function($$JornadasTableFilterComposer f) f,
  ) {
    final $$JornadasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.jornadas,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JornadasTableFilterComposer(
            $db: $db,
            $table: $db.jornadas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  Expression<T> jornadasRefs<T extends Object>(
    Expression<T> Function($$JornadasTableAnnotationComposer a) f,
  ) {
    final $$JornadasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.jornadas,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JornadasTableAnnotationComposer(
            $db: $db,
            $table: $db.jornadas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (Usuario, $$UsuariosTableReferences),
          Usuario,
          PrefetchHooks Function({bool jornadasRefs})
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$UsuariosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({jornadasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (jornadasRefs) db.jornadas],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (jornadasRefs)
                    await $_getPrefetchedData<Usuario, $UsuariosTable, Jornada>(
                      currentTable: table,
                      referencedTable: $$UsuariosTableReferences
                          ._jornadasRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$UsuariosTableReferences(db, table, p0).jornadasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.usuarioId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (Usuario, $$UsuariosTableReferences),
      Usuario,
      PrefetchHooks Function({bool jornadasRefs})
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

final class $$VeiculosTableReferences
    extends BaseReferences<_$AppDatabase, $VeiculosTable, Veiculo> {
  $$VeiculosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$JornadasTable, List<Jornada>> _jornadasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.jornadas,
    aliasName: 'veiculos__id__jornadas__veiculo_id',
  );

  $$JornadasTableProcessedTableManager get jornadasRefs {
    final manager = $$JornadasTableTableManager(
      $_db,
      $_db.jornadas,
    ).filter((f) => f.veiculoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_jornadasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  Expression<bool> jornadasRefs(
    Expression<bool> Function($$JornadasTableFilterComposer f) f,
  ) {
    final $$JornadasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.jornadas,
      getReferencedColumn: (t) => t.veiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JornadasTableFilterComposer(
            $db: $db,
            $table: $db.jornadas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  Expression<T> jornadasRefs<T extends Object>(
    Expression<T> Function($$JornadasTableAnnotationComposer a) f,
  ) {
    final $$JornadasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.jornadas,
      getReferencedColumn: (t) => t.veiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JornadasTableAnnotationComposer(
            $db: $db,
            $table: $db.jornadas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (Veiculo, $$VeiculosTableReferences),
          Veiculo,
          PrefetchHooks Function({bool jornadasRefs})
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$VeiculosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({jornadasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (jornadasRefs) db.jornadas],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (jornadasRefs)
                    await $_getPrefetchedData<Veiculo, $VeiculosTable, Jornada>(
                      currentTable: table,
                      referencedTable: $$VeiculosTableReferences
                          ._jornadasRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$VeiculosTableReferences(db, table, p0).jornadasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.veiculoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (Veiculo, $$VeiculosTableReferences),
      Veiculo,
      PrefetchHooks Function({bool jornadasRefs})
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
typedef $$JornadasTableCreateCompanionBuilder =
    JornadasCompanion Function({
      Value<int> id,
      required int usuarioId,
      required int veiculoId,
      required DateTime dataHoraInicio,
      Value<DateTime?> dataHoraFim,
      required int odometroInicio,
      Value<int?> odometroFim,
      required String cidadeOrigem,
      Value<String?> cidadeDestino,
      required StatusJornada status,
      Value<bool> odometroAlterado,
      Value<String?> observacoes,
      Value<DateTime> dataCriacao,
      Value<DateTime> dataAtualizacao,
      Value<int?> quilometrosPercorridos,
    });
typedef $$JornadasTableUpdateCompanionBuilder =
    JornadasCompanion Function({
      Value<int> id,
      Value<int> usuarioId,
      Value<int> veiculoId,
      Value<DateTime> dataHoraInicio,
      Value<DateTime?> dataHoraFim,
      Value<int> odometroInicio,
      Value<int?> odometroFim,
      Value<String> cidadeOrigem,
      Value<String?> cidadeDestino,
      Value<StatusJornada> status,
      Value<bool> odometroAlterado,
      Value<String?> observacoes,
      Value<DateTime> dataCriacao,
      Value<DateTime> dataAtualizacao,
      Value<int?> quilometrosPercorridos,
    });

final class $$JornadasTableReferences
    extends BaseReferences<_$AppDatabase, $JornadasTable, Jornada> {
  $$JornadasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsuariosTable _usuarioIdTable(_$AppDatabase db) =>
      db.usuarios.createAlias('jornadas__usuario_id__usuarios__id');

  $$UsuariosTableProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $$UsuariosTableTableManager(
      $_db,
      $_db.usuarios,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VeiculosTable _veiculoIdTable(_$AppDatabase db) =>
      db.veiculos.createAlias('jornadas__veiculo_id__veiculos__id');

  $$VeiculosTableProcessedTableManager get veiculoId {
    final $_column = $_itemColumn<int>('veiculo_id')!;

    final manager = $$VeiculosTableTableManager(
      $_db,
      $_db.veiculos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_veiculoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PausasTable, List<Pausa>> _pausasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.pausas,
    aliasName: 'jornadas__id__pausas__jornada_id',
  );

  $$PausasTableProcessedTableManager get pausasRefs {
    final manager = $$PausasTableTableManager(
      $_db,
      $_db.pausas,
    ).filter((f) => f.jornadaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pausasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$JornadasTableFilterComposer
    extends Composer<_$AppDatabase, $JornadasTable> {
  $$JornadasTableFilterComposer({
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

  ColumnFilters<DateTime> get dataHoraInicio => $composableBuilder(
    column: $table.dataHoraInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataHoraFim => $composableBuilder(
    column: $table.dataHoraFim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odometroInicio => $composableBuilder(
    column: $table.odometroInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odometroFim => $composableBuilder(
    column: $table.odometroFim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cidadeOrigem => $composableBuilder(
    column: $table.cidadeOrigem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cidadeDestino => $composableBuilder(
    column: $table.cidadeDestino,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StatusJornada, StatusJornada, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get odometroAlterado => $composableBuilder(
    column: $table.odometroAlterado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quilometrosPercorridos => $composableBuilder(
    column: $table.quilometrosPercorridos,
    builder: (column) => ColumnFilters(column),
  );

  $$UsuariosTableFilterComposer get usuarioId {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableFilterComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VeiculosTableFilterComposer get veiculoId {
    final $$VeiculosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.veiculoId,
      referencedTable: $db.veiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VeiculosTableFilterComposer(
            $db: $db,
            $table: $db.veiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> pausasRefs(
    Expression<bool> Function($$PausasTableFilterComposer f) f,
  ) {
    final $$PausasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pausas,
      getReferencedColumn: (t) => t.jornadaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PausasTableFilterComposer(
            $db: $db,
            $table: $db.pausas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JornadasTableOrderingComposer
    extends Composer<_$AppDatabase, $JornadasTable> {
  $$JornadasTableOrderingComposer({
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

  ColumnOrderings<DateTime> get dataHoraInicio => $composableBuilder(
    column: $table.dataHoraInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataHoraFim => $composableBuilder(
    column: $table.dataHoraFim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odometroInicio => $composableBuilder(
    column: $table.odometroInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odometroFim => $composableBuilder(
    column: $table.odometroFim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cidadeOrigem => $composableBuilder(
    column: $table.cidadeOrigem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cidadeDestino => $composableBuilder(
    column: $table.cidadeDestino,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get odometroAlterado => $composableBuilder(
    column: $table.odometroAlterado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quilometrosPercorridos => $composableBuilder(
    column: $table.quilometrosPercorridos,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsuariosTableOrderingComposer get usuarioId {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableOrderingComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VeiculosTableOrderingComposer get veiculoId {
    final $$VeiculosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.veiculoId,
      referencedTable: $db.veiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VeiculosTableOrderingComposer(
            $db: $db,
            $table: $db.veiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JornadasTableAnnotationComposer
    extends Composer<_$AppDatabase, $JornadasTable> {
  $$JornadasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataHoraInicio => $composableBuilder(
    column: $table.dataHoraInicio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataHoraFim => $composableBuilder(
    column: $table.dataHoraFim,
    builder: (column) => column,
  );

  GeneratedColumn<int> get odometroInicio => $composableBuilder(
    column: $table.odometroInicio,
    builder: (column) => column,
  );

  GeneratedColumn<int> get odometroFim => $composableBuilder(
    column: $table.odometroFim,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cidadeOrigem => $composableBuilder(
    column: $table.cidadeOrigem,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cidadeDestino => $composableBuilder(
    column: $table.cidadeDestino,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<StatusJornada, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get odometroAlterado => $composableBuilder(
    column: $table.odometroAlterado,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quilometrosPercorridos => $composableBuilder(
    column: $table.quilometrosPercorridos,
    builder: (column) => column,
  );

  $$UsuariosTableAnnotationComposer get usuarioId {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuarios,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsuariosTableAnnotationComposer(
            $db: $db,
            $table: $db.usuarios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VeiculosTableAnnotationComposer get veiculoId {
    final $$VeiculosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.veiculoId,
      referencedTable: $db.veiculos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VeiculosTableAnnotationComposer(
            $db: $db,
            $table: $db.veiculos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> pausasRefs<T extends Object>(
    Expression<T> Function($$PausasTableAnnotationComposer a) f,
  ) {
    final $$PausasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pausas,
      getReferencedColumn: (t) => t.jornadaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PausasTableAnnotationComposer(
            $db: $db,
            $table: $db.pausas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JornadasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JornadasTable,
          Jornada,
          $$JornadasTableFilterComposer,
          $$JornadasTableOrderingComposer,
          $$JornadasTableAnnotationComposer,
          $$JornadasTableCreateCompanionBuilder,
          $$JornadasTableUpdateCompanionBuilder,
          (Jornada, $$JornadasTableReferences),
          Jornada,
          PrefetchHooks Function({
            bool usuarioId,
            bool veiculoId,
            bool pausasRefs,
          })
        > {
  $$JornadasTableTableManager(_$AppDatabase db, $JornadasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JornadasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JornadasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JornadasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<int> veiculoId = const Value.absent(),
                Value<DateTime> dataHoraInicio = const Value.absent(),
                Value<DateTime?> dataHoraFim = const Value.absent(),
                Value<int> odometroInicio = const Value.absent(),
                Value<int?> odometroFim = const Value.absent(),
                Value<String> cidadeOrigem = const Value.absent(),
                Value<String?> cidadeDestino = const Value.absent(),
                Value<StatusJornada> status = const Value.absent(),
                Value<bool> odometroAlterado = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime> dataAtualizacao = const Value.absent(),
                Value<int?> quilometrosPercorridos = const Value.absent(),
              }) => JornadasCompanion(
                id: id,
                usuarioId: usuarioId,
                veiculoId: veiculoId,
                dataHoraInicio: dataHoraInicio,
                dataHoraFim: dataHoraFim,
                odometroInicio: odometroInicio,
                odometroFim: odometroFim,
                cidadeOrigem: cidadeOrigem,
                cidadeDestino: cidadeDestino,
                status: status,
                odometroAlterado: odometroAlterado,
                observacoes: observacoes,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
                quilometrosPercorridos: quilometrosPercorridos,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int usuarioId,
                required int veiculoId,
                required DateTime dataHoraInicio,
                Value<DateTime?> dataHoraFim = const Value.absent(),
                required int odometroInicio,
                Value<int?> odometroFim = const Value.absent(),
                required String cidadeOrigem,
                Value<String?> cidadeDestino = const Value.absent(),
                required StatusJornada status,
                Value<bool> odometroAlterado = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime> dataAtualizacao = const Value.absent(),
                Value<int?> quilometrosPercorridos = const Value.absent(),
              }) => JornadasCompanion.insert(
                id: id,
                usuarioId: usuarioId,
                veiculoId: veiculoId,
                dataHoraInicio: dataHoraInicio,
                dataHoraFim: dataHoraFim,
                odometroInicio: odometroInicio,
                odometroFim: odometroFim,
                cidadeOrigem: cidadeOrigem,
                cidadeDestino: cidadeDestino,
                status: status,
                odometroAlterado: odometroAlterado,
                observacoes: observacoes,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
                quilometrosPercorridos: quilometrosPercorridos,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JornadasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({usuarioId = false, veiculoId = false, pausasRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (pausasRefs) db.pausas],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (usuarioId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.usuarioId,
                                    referencedTable: $$JornadasTableReferences
                                        ._usuarioIdTable(db),
                                    referencedColumn: $$JornadasTableReferences
                                        ._usuarioIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (veiculoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.veiculoId,
                                    referencedTable: $$JornadasTableReferences
                                        ._veiculoIdTable(db),
                                    referencedColumn: $$JornadasTableReferences
                                        ._veiculoIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (pausasRefs)
                        await $_getPrefetchedData<
                          Jornada,
                          $JornadasTable,
                          Pausa
                        >(
                          currentTable: table,
                          referencedTable: $$JornadasTableReferences
                              ._pausasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JornadasTableReferences(
                                db,
                                table,
                                p0,
                              ).pausasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jornadaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$JornadasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JornadasTable,
      Jornada,
      $$JornadasTableFilterComposer,
      $$JornadasTableOrderingComposer,
      $$JornadasTableAnnotationComposer,
      $$JornadasTableCreateCompanionBuilder,
      $$JornadasTableUpdateCompanionBuilder,
      (Jornada, $$JornadasTableReferences),
      Jornada,
      PrefetchHooks Function({bool usuarioId, bool veiculoId, bool pausasRefs})
    >;
typedef $$PausasTableCreateCompanionBuilder =
    PausasCompanion Function({
      Value<int> id,
      required int jornadaId,
      required DateTime inicio,
      Value<DateTime?> fim,
      Value<String?> motivo,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
      Value<bool> registrarGanhos,
      Value<bool> concluida,
    });
typedef $$PausasTableUpdateCompanionBuilder =
    PausasCompanion Function({
      Value<int> id,
      Value<int> jornadaId,
      Value<DateTime> inicio,
      Value<DateTime?> fim,
      Value<String?> motivo,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
      Value<bool> registrarGanhos,
      Value<bool> concluida,
    });

final class $$PausasTableReferences
    extends BaseReferences<_$AppDatabase, $PausasTable, Pausa> {
  $$PausasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $JornadasTable _jornadaIdTable(_$AppDatabase db) =>
      db.jornadas.createAlias('pausas__jornada_id__jornadas__id');

  $$JornadasTableProcessedTableManager get jornadaId {
    final $_column = $_itemColumn<int>('jornada_id')!;

    final manager = $$JornadasTableTableManager(
      $_db,
      $_db.jornadas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jornadaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GanhosTable, List<Ganho>> _ganhosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ganhos,
    aliasName: 'pausas__id__ganhos__pausa_id',
  );

  $$GanhosTableProcessedTableManager get ganhosRefs {
    final manager = $$GanhosTableTableManager(
      $_db,
      $_db.ganhos,
    ).filter((f) => f.pausaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ganhosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PausasTableFilterComposer
    extends Composer<_$AppDatabase, $PausasTable> {
  $$PausasTableFilterComposer({
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

  ColumnFilters<DateTime> get inicio => $composableBuilder(
    column: $table.inicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fim => $composableBuilder(
    column: $table.fim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motivo => $composableBuilder(
    column: $table.motivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get registrarGanhos => $composableBuilder(
    column: $table.registrarGanhos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get concluida => $composableBuilder(
    column: $table.concluida,
    builder: (column) => ColumnFilters(column),
  );

  $$JornadasTableFilterComposer get jornadaId {
    final $$JornadasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jornadaId,
      referencedTable: $db.jornadas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JornadasTableFilterComposer(
            $db: $db,
            $table: $db.jornadas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ganhosRefs(
    Expression<bool> Function($$GanhosTableFilterComposer f) f,
  ) {
    final $$GanhosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ganhos,
      getReferencedColumn: (t) => t.pausaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GanhosTableFilterComposer(
            $db: $db,
            $table: $db.ganhos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PausasTableOrderingComposer
    extends Composer<_$AppDatabase, $PausasTable> {
  $$PausasTableOrderingComposer({
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

  ColumnOrderings<DateTime> get inicio => $composableBuilder(
    column: $table.inicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fim => $composableBuilder(
    column: $table.fim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivo => $composableBuilder(
    column: $table.motivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get registrarGanhos => $composableBuilder(
    column: $table.registrarGanhos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get concluida => $composableBuilder(
    column: $table.concluida,
    builder: (column) => ColumnOrderings(column),
  );

  $$JornadasTableOrderingComposer get jornadaId {
    final $$JornadasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jornadaId,
      referencedTable: $db.jornadas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JornadasTableOrderingComposer(
            $db: $db,
            $table: $db.jornadas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PausasTableAnnotationComposer
    extends Composer<_$AppDatabase, $PausasTable> {
  $$PausasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get inicio =>
      $composableBuilder(column: $table.inicio, builder: (column) => column);

  GeneratedColumn<DateTime> get fim =>
      $composableBuilder(column: $table.fim, builder: (column) => column);

  GeneratedColumn<String> get motivo =>
      $composableBuilder(column: $table.motivo, builder: (column) => column);

  GeneratedColumn<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get registrarGanhos => $composableBuilder(
    column: $table.registrarGanhos,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get concluida =>
      $composableBuilder(column: $table.concluida, builder: (column) => column);

  $$JornadasTableAnnotationComposer get jornadaId {
    final $$JornadasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jornadaId,
      referencedTable: $db.jornadas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JornadasTableAnnotationComposer(
            $db: $db,
            $table: $db.jornadas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ganhosRefs<T extends Object>(
    Expression<T> Function($$GanhosTableAnnotationComposer a) f,
  ) {
    final $$GanhosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ganhos,
      getReferencedColumn: (t) => t.pausaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GanhosTableAnnotationComposer(
            $db: $db,
            $table: $db.ganhos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PausasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PausasTable,
          Pausa,
          $$PausasTableFilterComposer,
          $$PausasTableOrderingComposer,
          $$PausasTableAnnotationComposer,
          $$PausasTableCreateCompanionBuilder,
          $$PausasTableUpdateCompanionBuilder,
          (Pausa, $$PausasTableReferences),
          Pausa,
          PrefetchHooks Function({bool jornadaId, bool ganhosRefs})
        > {
  $$PausasTableTableManager(_$AppDatabase db, $PausasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PausasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PausasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PausasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> jornadaId = const Value.absent(),
                Value<DateTime> inicio = const Value.absent(),
                Value<DateTime?> fim = const Value.absent(),
                Value<String?> motivo = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<bool> registrarGanhos = const Value.absent(),
                Value<bool> concluida = const Value.absent(),
              }) => PausasCompanion(
                id: id,
                jornadaId: jornadaId,
                inicio: inicio,
                fim: fim,
                motivo: motivo,
                observacao: observacao,
                dataCriacao: dataCriacao,
                registrarGanhos: registrarGanhos,
                concluida: concluida,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int jornadaId,
                required DateTime inicio,
                Value<DateTime?> fim = const Value.absent(),
                Value<String?> motivo = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<bool> registrarGanhos = const Value.absent(),
                Value<bool> concluida = const Value.absent(),
              }) => PausasCompanion.insert(
                id: id,
                jornadaId: jornadaId,
                inicio: inicio,
                fim: fim,
                motivo: motivo,
                observacao: observacao,
                dataCriacao: dataCriacao,
                registrarGanhos: registrarGanhos,
                concluida: concluida,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PausasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({jornadaId = false, ganhosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ganhosRefs) db.ganhos],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (jornadaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.jornadaId,
                                referencedTable: $$PausasTableReferences
                                    ._jornadaIdTable(db),
                                referencedColumn: $$PausasTableReferences
                                    ._jornadaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ganhosRefs)
                    await $_getPrefetchedData<Pausa, $PausasTable, Ganho>(
                      currentTable: table,
                      referencedTable: $$PausasTableReferences._ganhosRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$PausasTableReferences(db, table, p0).ganhosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.pausaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PausasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PausasTable,
      Pausa,
      $$PausasTableFilterComposer,
      $$PausasTableOrderingComposer,
      $$PausasTableAnnotationComposer,
      $$PausasTableCreateCompanionBuilder,
      $$PausasTableUpdateCompanionBuilder,
      (Pausa, $$PausasTableReferences),
      Pausa,
      PrefetchHooks Function({bool jornadaId, bool ganhosRefs})
    >;
typedef $$PlataformasTableCreateCompanionBuilder =
    PlataformasCompanion Function({
      Value<int> id,
      required String nome,
      Value<String?> icone,
      Value<String?> cor,
      Value<bool> ativa,
      Value<int> ordem,
      Value<DateTime> dataCriacao,
    });
typedef $$PlataformasTableUpdateCompanionBuilder =
    PlataformasCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<String?> icone,
      Value<String?> cor,
      Value<bool> ativa,
      Value<int> ordem,
      Value<DateTime> dataCriacao,
    });

final class $$PlataformasTableReferences
    extends BaseReferences<_$AppDatabase, $PlataformasTable, Plataforma> {
  $$PlataformasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GanhosTable, List<Ganho>> _ganhosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ganhos,
    aliasName: 'plataformas__id__ganhos__plataforma_id',
  );

  $$GanhosTableProcessedTableManager get ganhosRefs {
    final manager = $$GanhosTableTableManager(
      $_db,
      $_db.ganhos,
    ).filter((f) => f.plataformaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ganhosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlataformasTableFilterComposer
    extends Composer<_$AppDatabase, $PlataformasTable> {
  $$PlataformasTableFilterComposer({
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

  ColumnFilters<String> get icone => $composableBuilder(
    column: $table.icone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cor => $composableBuilder(
    column: $table.cor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativa => $composableBuilder(
    column: $table.ativa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ganhosRefs(
    Expression<bool> Function($$GanhosTableFilterComposer f) f,
  ) {
    final $$GanhosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ganhos,
      getReferencedColumn: (t) => t.plataformaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GanhosTableFilterComposer(
            $db: $db,
            $table: $db.ganhos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlataformasTableOrderingComposer
    extends Composer<_$AppDatabase, $PlataformasTable> {
  $$PlataformasTableOrderingComposer({
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

  ColumnOrderings<String> get icone => $composableBuilder(
    column: $table.icone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cor => $composableBuilder(
    column: $table.cor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativa => $composableBuilder(
    column: $table.ativa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlataformasTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlataformasTable> {
  $$PlataformasTableAnnotationComposer({
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

  GeneratedColumn<String> get icone =>
      $composableBuilder(column: $table.icone, builder: (column) => column);

  GeneratedColumn<String> get cor =>
      $composableBuilder(column: $table.cor, builder: (column) => column);

  GeneratedColumn<bool> get ativa =>
      $composableBuilder(column: $table.ativa, builder: (column) => column);

  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  Expression<T> ganhosRefs<T extends Object>(
    Expression<T> Function($$GanhosTableAnnotationComposer a) f,
  ) {
    final $$GanhosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ganhos,
      getReferencedColumn: (t) => t.plataformaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GanhosTableAnnotationComposer(
            $db: $db,
            $table: $db.ganhos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlataformasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlataformasTable,
          Plataforma,
          $$PlataformasTableFilterComposer,
          $$PlataformasTableOrderingComposer,
          $$PlataformasTableAnnotationComposer,
          $$PlataformasTableCreateCompanionBuilder,
          $$PlataformasTableUpdateCompanionBuilder,
          (Plataforma, $$PlataformasTableReferences),
          Plataforma,
          PrefetchHooks Function({bool ganhosRefs})
        > {
  $$PlataformasTableTableManager(_$AppDatabase db, $PlataformasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlataformasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlataformasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlataformasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> icone = const Value.absent(),
                Value<String?> cor = const Value.absent(),
                Value<bool> ativa = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => PlataformasCompanion(
                id: id,
                nome: nome,
                icone: icone,
                cor: cor,
                ativa: ativa,
                ordem: ordem,
                dataCriacao: dataCriacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                Value<String?> icone = const Value.absent(),
                Value<String?> cor = const Value.absent(),
                Value<bool> ativa = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => PlataformasCompanion.insert(
                id: id,
                nome: nome,
                icone: icone,
                cor: cor,
                ativa: ativa,
                ordem: ordem,
                dataCriacao: dataCriacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlataformasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ganhosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ganhosRefs) db.ganhos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ganhosRefs)
                    await $_getPrefetchedData<
                      Plataforma,
                      $PlataformasTable,
                      Ganho
                    >(
                      currentTable: table,
                      referencedTable: $$PlataformasTableReferences
                          ._ganhosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PlataformasTableReferences(
                            db,
                            table,
                            p0,
                          ).ganhosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.plataformaId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlataformasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlataformasTable,
      Plataforma,
      $$PlataformasTableFilterComposer,
      $$PlataformasTableOrderingComposer,
      $$PlataformasTableAnnotationComposer,
      $$PlataformasTableCreateCompanionBuilder,
      $$PlataformasTableUpdateCompanionBuilder,
      (Plataforma, $$PlataformasTableReferences),
      Plataforma,
      PrefetchHooks Function({bool ganhosRefs})
    >;
typedef $$GanhosTableCreateCompanionBuilder =
    GanhosCompanion Function({
      Value<int> id,
      required int pausaId,
      required int plataformaId,
      required double valor,
      Value<int> quantidadeCorridas,
      Value<bool> registroFinal,
      Value<DateTime> dataCriacao,
    });
typedef $$GanhosTableUpdateCompanionBuilder =
    GanhosCompanion Function({
      Value<int> id,
      Value<int> pausaId,
      Value<int> plataformaId,
      Value<double> valor,
      Value<int> quantidadeCorridas,
      Value<bool> registroFinal,
      Value<DateTime> dataCriacao,
    });

final class $$GanhosTableReferences
    extends BaseReferences<_$AppDatabase, $GanhosTable, Ganho> {
  $$GanhosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PausasTable _pausaIdTable(_$AppDatabase db) =>
      db.pausas.createAlias('ganhos__pausa_id__pausas__id');

  $$PausasTableProcessedTableManager get pausaId {
    final $_column = $_itemColumn<int>('pausa_id')!;

    final manager = $$PausasTableTableManager(
      $_db,
      $_db.pausas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pausaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlataformasTable _plataformaIdTable(_$AppDatabase db) =>
      db.plataformas.createAlias('ganhos__plataforma_id__plataformas__id');

  $$PlataformasTableProcessedTableManager get plataformaId {
    final $_column = $_itemColumn<int>('plataforma_id')!;

    final manager = $$PlataformasTableTableManager(
      $_db,
      $_db.plataformas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_plataformaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GanhosTableFilterComposer
    extends Composer<_$AppDatabase, $GanhosTable> {
  $$GanhosTableFilterComposer({
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

  ColumnFilters<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantidadeCorridas => $composableBuilder(
    column: $table.quantidadeCorridas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get registroFinal => $composableBuilder(
    column: $table.registroFinal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  $$PausasTableFilterComposer get pausaId {
    final $$PausasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pausaId,
      referencedTable: $db.pausas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PausasTableFilterComposer(
            $db: $db,
            $table: $db.pausas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlataformasTableFilterComposer get plataformaId {
    final $$PlataformasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plataformaId,
      referencedTable: $db.plataformas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlataformasTableFilterComposer(
            $db: $db,
            $table: $db.plataformas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GanhosTableOrderingComposer
    extends Composer<_$AppDatabase, $GanhosTable> {
  $$GanhosTableOrderingComposer({
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

  ColumnOrderings<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantidadeCorridas => $composableBuilder(
    column: $table.quantidadeCorridas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get registroFinal => $composableBuilder(
    column: $table.registroFinal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );

  $$PausasTableOrderingComposer get pausaId {
    final $$PausasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pausaId,
      referencedTable: $db.pausas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PausasTableOrderingComposer(
            $db: $db,
            $table: $db.pausas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlataformasTableOrderingComposer get plataformaId {
    final $$PlataformasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plataformaId,
      referencedTable: $db.plataformas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlataformasTableOrderingComposer(
            $db: $db,
            $table: $db.plataformas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GanhosTableAnnotationComposer
    extends Composer<_$AppDatabase, $GanhosTable> {
  $$GanhosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumn<int> get quantidadeCorridas => $composableBuilder(
    column: $table.quantidadeCorridas,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get registroFinal => $composableBuilder(
    column: $table.registroFinal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  $$PausasTableAnnotationComposer get pausaId {
    final $$PausasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pausaId,
      referencedTable: $db.pausas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PausasTableAnnotationComposer(
            $db: $db,
            $table: $db.pausas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlataformasTableAnnotationComposer get plataformaId {
    final $$PlataformasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plataformaId,
      referencedTable: $db.plataformas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlataformasTableAnnotationComposer(
            $db: $db,
            $table: $db.plataformas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GanhosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GanhosTable,
          Ganho,
          $$GanhosTableFilterComposer,
          $$GanhosTableOrderingComposer,
          $$GanhosTableAnnotationComposer,
          $$GanhosTableCreateCompanionBuilder,
          $$GanhosTableUpdateCompanionBuilder,
          (Ganho, $$GanhosTableReferences),
          Ganho,
          PrefetchHooks Function({bool pausaId, bool plataformaId})
        > {
  $$GanhosTableTableManager(_$AppDatabase db, $GanhosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GanhosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GanhosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GanhosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pausaId = const Value.absent(),
                Value<int> plataformaId = const Value.absent(),
                Value<double> valor = const Value.absent(),
                Value<int> quantidadeCorridas = const Value.absent(),
                Value<bool> registroFinal = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => GanhosCompanion(
                id: id,
                pausaId: pausaId,
                plataformaId: plataformaId,
                valor: valor,
                quantidadeCorridas: quantidadeCorridas,
                registroFinal: registroFinal,
                dataCriacao: dataCriacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pausaId,
                required int plataformaId,
                required double valor,
                Value<int> quantidadeCorridas = const Value.absent(),
                Value<bool> registroFinal = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => GanhosCompanion.insert(
                id: id,
                pausaId: pausaId,
                plataformaId: plataformaId,
                valor: valor,
                quantidadeCorridas: quantidadeCorridas,
                registroFinal: registroFinal,
                dataCriacao: dataCriacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GanhosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({pausaId = false, plataformaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pausaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pausaId,
                                referencedTable: $$GanhosTableReferences
                                    ._pausaIdTable(db),
                                referencedColumn: $$GanhosTableReferences
                                    ._pausaIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (plataformaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.plataformaId,
                                referencedTable: $$GanhosTableReferences
                                    ._plataformaIdTable(db),
                                referencedColumn: $$GanhosTableReferences
                                    ._plataformaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GanhosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GanhosTable,
      Ganho,
      $$GanhosTableFilterComposer,
      $$GanhosTableOrderingComposer,
      $$GanhosTableAnnotationComposer,
      $$GanhosTableCreateCompanionBuilder,
      $$GanhosTableUpdateCompanionBuilder,
      (Ganho, $$GanhosTableReferences),
      Ganho,
      PrefetchHooks Function({bool pausaId, bool plataformaId})
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
  $$JornadasTableTableManager get jornadas =>
      $$JornadasTableTableManager(_db, _db.jornadas);
  $$PausasTableTableManager get pausas =>
      $$PausasTableTableManager(_db, _db.pausas);
  $$PlataformasTableTableManager get plataformas =>
      $$PlataformasTableTableManager(_db, _db.plataformas);
  $$GanhosTableTableManager get ganhos =>
      $$GanhosTableTableManager(_db, _db.ganhos);
}
