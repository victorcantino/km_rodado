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
  static const VerificationMeta _odometroInicioMeta = const VerificationMeta(
    'odometroInicio',
  );
  @override
  late final GeneratedColumn<int> odometroInicio = GeneratedColumn<int>(
    'odometro_inicio',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jornadaId,
    inicio,
    fim,
    odometroInicio,
    odometroFim,
    titulo,
    observacao,
    dataCriacao,
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
    if (data.containsKey('odometro_inicio')) {
      context.handle(
        _odometroInicioMeta,
        odometroInicio.isAcceptableOrUnknown(
          data['odometro_inicio']!,
          _odometroInicioMeta,
        ),
      );
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
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
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
      odometroInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odometro_inicio'],
      ),
      odometroFim: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odometro_fim'],
      ),
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      ),
      observacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacao'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
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
  final int? odometroInicio;
  final int? odometroFim;
  final String? titulo;
  final String? observacao;
  final DateTime dataCriacao;
  const Pausa({
    required this.id,
    required this.jornadaId,
    required this.inicio,
    this.fim,
    this.odometroInicio,
    this.odometroFim,
    this.titulo,
    this.observacao,
    required this.dataCriacao,
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
    if (!nullToAbsent || odometroInicio != null) {
      map['odometro_inicio'] = Variable<int>(odometroInicio);
    }
    if (!nullToAbsent || odometroFim != null) {
      map['odometro_fim'] = Variable<int>(odometroFim);
    }
    if (!nullToAbsent || titulo != null) {
      map['titulo'] = Variable<String>(titulo);
    }
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    return map;
  }

  PausasCompanion toCompanion(bool nullToAbsent) {
    return PausasCompanion(
      id: Value(id),
      jornadaId: Value(jornadaId),
      inicio: Value(inicio),
      fim: fim == null && nullToAbsent ? const Value.absent() : Value(fim),
      odometroInicio: odometroInicio == null && nullToAbsent
          ? const Value.absent()
          : Value(odometroInicio),
      odometroFim: odometroFim == null && nullToAbsent
          ? const Value.absent()
          : Value(odometroFim),
      titulo: titulo == null && nullToAbsent
          ? const Value.absent()
          : Value(titulo),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
      dataCriacao: Value(dataCriacao),
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
      odometroInicio: serializer.fromJson<int?>(json['odometroInicio']),
      odometroFim: serializer.fromJson<int?>(json['odometroFim']),
      titulo: serializer.fromJson<String?>(json['titulo']),
      observacao: serializer.fromJson<String?>(json['observacao']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
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
      'odometroInicio': serializer.toJson<int?>(odometroInicio),
      'odometroFim': serializer.toJson<int?>(odometroFim),
      'titulo': serializer.toJson<String?>(titulo),
      'observacao': serializer.toJson<String?>(observacao),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
    };
  }

  Pausa copyWith({
    int? id,
    int? jornadaId,
    DateTime? inicio,
    Value<DateTime?> fim = const Value.absent(),
    Value<int?> odometroInicio = const Value.absent(),
    Value<int?> odometroFim = const Value.absent(),
    Value<String?> titulo = const Value.absent(),
    Value<String?> observacao = const Value.absent(),
    DateTime? dataCriacao,
  }) => Pausa(
    id: id ?? this.id,
    jornadaId: jornadaId ?? this.jornadaId,
    inicio: inicio ?? this.inicio,
    fim: fim.present ? fim.value : this.fim,
    odometroInicio: odometroInicio.present
        ? odometroInicio.value
        : this.odometroInicio,
    odometroFim: odometroFim.present ? odometroFim.value : this.odometroFim,
    titulo: titulo.present ? titulo.value : this.titulo,
    observacao: observacao.present ? observacao.value : this.observacao,
    dataCriacao: dataCriacao ?? this.dataCriacao,
  );
  Pausa copyWithCompanion(PausasCompanion data) {
    return Pausa(
      id: data.id.present ? data.id.value : this.id,
      jornadaId: data.jornadaId.present ? data.jornadaId.value : this.jornadaId,
      inicio: data.inicio.present ? data.inicio.value : this.inicio,
      fim: data.fim.present ? data.fim.value : this.fim,
      odometroInicio: data.odometroInicio.present
          ? data.odometroInicio.value
          : this.odometroInicio,
      odometroFim: data.odometroFim.present
          ? data.odometroFim.value
          : this.odometroFim,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      observacao: data.observacao.present
          ? data.observacao.value
          : this.observacao,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pausa(')
          ..write('id: $id, ')
          ..write('jornadaId: $jornadaId, ')
          ..write('inicio: $inicio, ')
          ..write('fim: $fim, ')
          ..write('odometroInicio: $odometroInicio, ')
          ..write('odometroFim: $odometroFim, ')
          ..write('titulo: $titulo, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jornadaId,
    inicio,
    fim,
    odometroInicio,
    odometroFim,
    titulo,
    observacao,
    dataCriacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pausa &&
          other.id == this.id &&
          other.jornadaId == this.jornadaId &&
          other.inicio == this.inicio &&
          other.fim == this.fim &&
          other.odometroInicio == this.odometroInicio &&
          other.odometroFim == this.odometroFim &&
          other.titulo == this.titulo &&
          other.observacao == this.observacao &&
          other.dataCriacao == this.dataCriacao);
}

class PausasCompanion extends UpdateCompanion<Pausa> {
  final Value<int> id;
  final Value<int> jornadaId;
  final Value<DateTime> inicio;
  final Value<DateTime?> fim;
  final Value<int?> odometroInicio;
  final Value<int?> odometroFim;
  final Value<String?> titulo;
  final Value<String?> observacao;
  final Value<DateTime> dataCriacao;
  const PausasCompanion({
    this.id = const Value.absent(),
    this.jornadaId = const Value.absent(),
    this.inicio = const Value.absent(),
    this.fim = const Value.absent(),
    this.odometroInicio = const Value.absent(),
    this.odometroFim = const Value.absent(),
    this.titulo = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  });
  PausasCompanion.insert({
    this.id = const Value.absent(),
    required int jornadaId,
    required DateTime inicio,
    this.fim = const Value.absent(),
    this.odometroInicio = const Value.absent(),
    this.odometroFim = const Value.absent(),
    this.titulo = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  }) : jornadaId = Value(jornadaId),
       inicio = Value(inicio);
  static Insertable<Pausa> custom({
    Expression<int>? id,
    Expression<int>? jornadaId,
    Expression<DateTime>? inicio,
    Expression<DateTime>? fim,
    Expression<int>? odometroInicio,
    Expression<int>? odometroFim,
    Expression<String>? titulo,
    Expression<String>? observacao,
    Expression<DateTime>? dataCriacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jornadaId != null) 'jornada_id': jornadaId,
      if (inicio != null) 'inicio': inicio,
      if (fim != null) 'fim': fim,
      if (odometroInicio != null) 'odometro_inicio': odometroInicio,
      if (odometroFim != null) 'odometro_fim': odometroFim,
      if (titulo != null) 'titulo': titulo,
      if (observacao != null) 'observacao': observacao,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
    });
  }

  PausasCompanion copyWith({
    Value<int>? id,
    Value<int>? jornadaId,
    Value<DateTime>? inicio,
    Value<DateTime?>? fim,
    Value<int?>? odometroInicio,
    Value<int?>? odometroFim,
    Value<String?>? titulo,
    Value<String?>? observacao,
    Value<DateTime>? dataCriacao,
  }) {
    return PausasCompanion(
      id: id ?? this.id,
      jornadaId: jornadaId ?? this.jornadaId,
      inicio: inicio ?? this.inicio,
      fim: fim ?? this.fim,
      odometroInicio: odometroInicio ?? this.odometroInicio,
      odometroFim: odometroFim ?? this.odometroFim,
      titulo: titulo ?? this.titulo,
      observacao: observacao ?? this.observacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
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
    if (odometroInicio.present) {
      map['odometro_inicio'] = Variable<int>(odometroInicio.value);
    }
    if (odometroFim.present) {
      map['odometro_fim'] = Variable<int>(odometroFim.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
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
          ..write('odometroInicio: $odometroInicio, ')
          ..write('odometroFim: $odometroFim, ')
          ..write('titulo: $titulo, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao')
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
  @override
  late final GeneratedColumnWithTypeConverter<TipoRegistroGanhos, String>
  tipoRegistroGanhos =
      GeneratedColumn<String>(
        'tipo_registro_ganhos',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoRegistroGanhos>(
        $PlataformasTable.$convertertipoRegistroGanhos,
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
    tipoRegistroGanhos,
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
      tipoRegistroGanhos: $PlataformasTable.$convertertipoRegistroGanhos
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}tipo_registro_ganhos'],
            )!,
          ),
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

  static JsonTypeConverter2<TipoRegistroGanhos, String, String>
  $convertertipoRegistroGanhos = const EnumNameConverter<TipoRegistroGanhos>(
    TipoRegistroGanhos.values,
  );
}

class Plataforma extends DataClass implements Insertable<Plataforma> {
  final int id;
  final String nome;
  final TipoRegistroGanhos tipoRegistroGanhos;
  final String? icone;
  final String? cor;
  final bool ativa;
  final int ordem;
  final DateTime dataCriacao;
  const Plataforma({
    required this.id,
    required this.nome,
    required this.tipoRegistroGanhos,
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
    {
      map['tipo_registro_ganhos'] = Variable<String>(
        $PlataformasTable.$convertertipoRegistroGanhos.toSql(
          tipoRegistroGanhos,
        ),
      );
    }
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
      tipoRegistroGanhos: Value(tipoRegistroGanhos),
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
      tipoRegistroGanhos: $PlataformasTable.$convertertipoRegistroGanhos
          .fromJson(serializer.fromJson<String>(json['tipoRegistroGanhos'])),
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
      'tipoRegistroGanhos': serializer.toJson<String>(
        $PlataformasTable.$convertertipoRegistroGanhos.toJson(
          tipoRegistroGanhos,
        ),
      ),
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
    TipoRegistroGanhos? tipoRegistroGanhos,
    Value<String?> icone = const Value.absent(),
    Value<String?> cor = const Value.absent(),
    bool? ativa,
    int? ordem,
    DateTime? dataCriacao,
  }) => Plataforma(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    tipoRegistroGanhos: tipoRegistroGanhos ?? this.tipoRegistroGanhos,
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
      tipoRegistroGanhos: data.tipoRegistroGanhos.present
          ? data.tipoRegistroGanhos.value
          : this.tipoRegistroGanhos,
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
          ..write('tipoRegistroGanhos: $tipoRegistroGanhos, ')
          ..write('icone: $icone, ')
          ..write('cor: $cor, ')
          ..write('ativa: $ativa, ')
          ..write('ordem: $ordem, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    tipoRegistroGanhos,
    icone,
    cor,
    ativa,
    ordem,
    dataCriacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plataforma &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.tipoRegistroGanhos == this.tipoRegistroGanhos &&
          other.icone == this.icone &&
          other.cor == this.cor &&
          other.ativa == this.ativa &&
          other.ordem == this.ordem &&
          other.dataCriacao == this.dataCriacao);
}

class PlataformasCompanion extends UpdateCompanion<Plataforma> {
  final Value<int> id;
  final Value<String> nome;
  final Value<TipoRegistroGanhos> tipoRegistroGanhos;
  final Value<String?> icone;
  final Value<String?> cor;
  final Value<bool> ativa;
  final Value<int> ordem;
  final Value<DateTime> dataCriacao;
  const PlataformasCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.tipoRegistroGanhos = const Value.absent(),
    this.icone = const Value.absent(),
    this.cor = const Value.absent(),
    this.ativa = const Value.absent(),
    this.ordem = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  });
  PlataformasCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required TipoRegistroGanhos tipoRegistroGanhos,
    this.icone = const Value.absent(),
    this.cor = const Value.absent(),
    this.ativa = const Value.absent(),
    this.ordem = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  }) : nome = Value(nome),
       tipoRegistroGanhos = Value(tipoRegistroGanhos);
  static Insertable<Plataforma> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? tipoRegistroGanhos,
    Expression<String>? icone,
    Expression<String>? cor,
    Expression<bool>? ativa,
    Expression<int>? ordem,
    Expression<DateTime>? dataCriacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (tipoRegistroGanhos != null)
        'tipo_registro_ganhos': tipoRegistroGanhos,
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
    Value<TipoRegistroGanhos>? tipoRegistroGanhos,
    Value<String?>? icone,
    Value<String?>? cor,
    Value<bool>? ativa,
    Value<int>? ordem,
    Value<DateTime>? dataCriacao,
  }) {
    return PlataformasCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      tipoRegistroGanhos: tipoRegistroGanhos ?? this.tipoRegistroGanhos,
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
    if (tipoRegistroGanhos.present) {
      map['tipo_registro_ganhos'] = Variable<String>(
        $PlataformasTable.$convertertipoRegistroGanhos.toSql(
          tipoRegistroGanhos.value,
        ),
      );
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
          ..write('tipoRegistroGanhos: $tipoRegistroGanhos, ')
          ..write('icone: $icone, ')
          ..write('cor: $cor, ')
          ..write('ativa: $ativa, ')
          ..write('ordem: $ordem, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }
}

class $LeiturasGanhosTable extends LeiturasGanhos
    with TableInfo<$LeiturasGanhosTable, LeiturasGanho> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeiturasGanhosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _pausaIdMeta = const VerificationMeta(
    'pausaId',
  );
  @override
  late final GeneratedColumn<int> pausaId = GeneratedColumn<int>(
    'pausa_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pausas (id)',
    ),
  );
  static const VerificationMeta _dataHoraMeta = const VerificationMeta(
    'dataHora',
  );
  @override
  late final GeneratedColumn<DateTime> dataHora = GeneratedColumn<DateTime>(
    'data_hora',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoLeituraGanhos, String> tipo =
      GeneratedColumn<String>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoLeituraGanhos>($LeiturasGanhosTable.$convertertipo);
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
    jornadaId,
    pausaId,
    dataHora,
    tipo,
    dataCriacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leituras_ganhos';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeiturasGanho> instance, {
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
    if (data.containsKey('pausa_id')) {
      context.handle(
        _pausaIdMeta,
        pausaId.isAcceptableOrUnknown(data['pausa_id']!, _pausaIdMeta),
      );
    }
    if (data.containsKey('data_hora')) {
      context.handle(
        _dataHoraMeta,
        dataHora.isAcceptableOrUnknown(data['data_hora']!, _dataHoraMeta),
      );
    } else if (isInserting) {
      context.missing(_dataHoraMeta);
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
  LeiturasGanho map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeiturasGanho(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      jornadaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jornada_id'],
      )!,
      pausaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pausa_id'],
      ),
      dataHora: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora'],
      )!,
      tipo: $LeiturasGanhosTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
    );
  }

  @override
  $LeiturasGanhosTable createAlias(String alias) {
    return $LeiturasGanhosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoLeituraGanhos, String, String> $convertertipo =
      const EnumNameConverter<TipoLeituraGanhos>(TipoLeituraGanhos.values);
}

class LeiturasGanho extends DataClass implements Insertable<LeiturasGanho> {
  final int id;
  final int jornadaId;
  final int? pausaId;
  final DateTime dataHora;
  final TipoLeituraGanhos tipo;
  final DateTime dataCriacao;
  const LeiturasGanho({
    required this.id,
    required this.jornadaId,
    this.pausaId,
    required this.dataHora,
    required this.tipo,
    required this.dataCriacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['jornada_id'] = Variable<int>(jornadaId);
    if (!nullToAbsent || pausaId != null) {
      map['pausa_id'] = Variable<int>(pausaId);
    }
    map['data_hora'] = Variable<DateTime>(dataHora);
    {
      map['tipo'] = Variable<String>(
        $LeiturasGanhosTable.$convertertipo.toSql(tipo),
      );
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    return map;
  }

  LeiturasGanhosCompanion toCompanion(bool nullToAbsent) {
    return LeiturasGanhosCompanion(
      id: Value(id),
      jornadaId: Value(jornadaId),
      pausaId: pausaId == null && nullToAbsent
          ? const Value.absent()
          : Value(pausaId),
      dataHora: Value(dataHora),
      tipo: Value(tipo),
      dataCriacao: Value(dataCriacao),
    );
  }

  factory LeiturasGanho.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeiturasGanho(
      id: serializer.fromJson<int>(json['id']),
      jornadaId: serializer.fromJson<int>(json['jornadaId']),
      pausaId: serializer.fromJson<int?>(json['pausaId']),
      dataHora: serializer.fromJson<DateTime>(json['dataHora']),
      tipo: $LeiturasGanhosTable.$convertertipo.fromJson(
        serializer.fromJson<String>(json['tipo']),
      ),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'jornadaId': serializer.toJson<int>(jornadaId),
      'pausaId': serializer.toJson<int?>(pausaId),
      'dataHora': serializer.toJson<DateTime>(dataHora),
      'tipo': serializer.toJson<String>(
        $LeiturasGanhosTable.$convertertipo.toJson(tipo),
      ),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
    };
  }

  LeiturasGanho copyWith({
    int? id,
    int? jornadaId,
    Value<int?> pausaId = const Value.absent(),
    DateTime? dataHora,
    TipoLeituraGanhos? tipo,
    DateTime? dataCriacao,
  }) => LeiturasGanho(
    id: id ?? this.id,
    jornadaId: jornadaId ?? this.jornadaId,
    pausaId: pausaId.present ? pausaId.value : this.pausaId,
    dataHora: dataHora ?? this.dataHora,
    tipo: tipo ?? this.tipo,
    dataCriacao: dataCriacao ?? this.dataCriacao,
  );
  LeiturasGanho copyWithCompanion(LeiturasGanhosCompanion data) {
    return LeiturasGanho(
      id: data.id.present ? data.id.value : this.id,
      jornadaId: data.jornadaId.present ? data.jornadaId.value : this.jornadaId,
      pausaId: data.pausaId.present ? data.pausaId.value : this.pausaId,
      dataHora: data.dataHora.present ? data.dataHora.value : this.dataHora,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeiturasGanho(')
          ..write('id: $id, ')
          ..write('jornadaId: $jornadaId, ')
          ..write('pausaId: $pausaId, ')
          ..write('dataHora: $dataHora, ')
          ..write('tipo: $tipo, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, jornadaId, pausaId, dataHora, tipo, dataCriacao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeiturasGanho &&
          other.id == this.id &&
          other.jornadaId == this.jornadaId &&
          other.pausaId == this.pausaId &&
          other.dataHora == this.dataHora &&
          other.tipo == this.tipo &&
          other.dataCriacao == this.dataCriacao);
}

class LeiturasGanhosCompanion extends UpdateCompanion<LeiturasGanho> {
  final Value<int> id;
  final Value<int> jornadaId;
  final Value<int?> pausaId;
  final Value<DateTime> dataHora;
  final Value<TipoLeituraGanhos> tipo;
  final Value<DateTime> dataCriacao;
  const LeiturasGanhosCompanion({
    this.id = const Value.absent(),
    this.jornadaId = const Value.absent(),
    this.pausaId = const Value.absent(),
    this.dataHora = const Value.absent(),
    this.tipo = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  });
  LeiturasGanhosCompanion.insert({
    this.id = const Value.absent(),
    required int jornadaId,
    this.pausaId = const Value.absent(),
    required DateTime dataHora,
    required TipoLeituraGanhos tipo,
    this.dataCriacao = const Value.absent(),
  }) : jornadaId = Value(jornadaId),
       dataHora = Value(dataHora),
       tipo = Value(tipo);
  static Insertable<LeiturasGanho> custom({
    Expression<int>? id,
    Expression<int>? jornadaId,
    Expression<int>? pausaId,
    Expression<DateTime>? dataHora,
    Expression<String>? tipo,
    Expression<DateTime>? dataCriacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jornadaId != null) 'jornada_id': jornadaId,
      if (pausaId != null) 'pausa_id': pausaId,
      if (dataHora != null) 'data_hora': dataHora,
      if (tipo != null) 'tipo': tipo,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
    });
  }

  LeiturasGanhosCompanion copyWith({
    Value<int>? id,
    Value<int>? jornadaId,
    Value<int?>? pausaId,
    Value<DateTime>? dataHora,
    Value<TipoLeituraGanhos>? tipo,
    Value<DateTime>? dataCriacao,
  }) {
    return LeiturasGanhosCompanion(
      id: id ?? this.id,
      jornadaId: jornadaId ?? this.jornadaId,
      pausaId: pausaId ?? this.pausaId,
      dataHora: dataHora ?? this.dataHora,
      tipo: tipo ?? this.tipo,
      dataCriacao: dataCriacao ?? this.dataCriacao,
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
    if (pausaId.present) {
      map['pausa_id'] = Variable<int>(pausaId.value);
    }
    if (dataHora.present) {
      map['data_hora'] = Variable<DateTime>(dataHora.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
        $LeiturasGanhosTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeiturasGanhosCompanion(')
          ..write('id: $id, ')
          ..write('jornadaId: $jornadaId, ')
          ..write('pausaId: $pausaId, ')
          ..write('dataHora: $dataHora, ')
          ..write('tipo: $tipo, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }
}

class $LeiturasGanhoPlataformaTable extends LeiturasGanhoPlataforma
    with TableInfo<$LeiturasGanhoPlataformaTable, LeiturasGanhoPlataformaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeiturasGanhoPlataformaTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _leituraGanhosIdMeta = const VerificationMeta(
    'leituraGanhosId',
  );
  @override
  late final GeneratedColumn<int> leituraGanhosId = GeneratedColumn<int>(
    'leitura_ganhos_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES leituras_ganhos (id)',
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
  static const VerificationMeta _valorAcumuladoCentavosMeta =
      const VerificationMeta('valorAcumuladoCentavos');
  @override
  late final GeneratedColumn<int> valorAcumuladoCentavos = GeneratedColumn<int>(
    'valor_acumulado_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantidadeViagensAcumuladaMeta =
      const VerificationMeta('quantidadeViagensAcumulada');
  @override
  late final GeneratedColumn<int> quantidadeViagensAcumulada =
      GeneratedColumn<int>(
        'quantidade_viagens_acumulada',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    leituraGanhosId,
    plataformaId,
    valorAcumuladoCentavos,
    quantidadeViagensAcumulada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leituras_ganho_plataforma';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeiturasGanhoPlataformaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('leitura_ganhos_id')) {
      context.handle(
        _leituraGanhosIdMeta,
        leituraGanhosId.isAcceptableOrUnknown(
          data['leitura_ganhos_id']!,
          _leituraGanhosIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_leituraGanhosIdMeta);
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
    if (data.containsKey('valor_acumulado_centavos')) {
      context.handle(
        _valorAcumuladoCentavosMeta,
        valorAcumuladoCentavos.isAcceptableOrUnknown(
          data['valor_acumulado_centavos']!,
          _valorAcumuladoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorAcumuladoCentavosMeta);
    }
    if (data.containsKey('quantidade_viagens_acumulada')) {
      context.handle(
        _quantidadeViagensAcumuladaMeta,
        quantidadeViagensAcumulada.isAcceptableOrUnknown(
          data['quantidade_viagens_acumulada']!,
          _quantidadeViagensAcumuladaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantidadeViagensAcumuladaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {leituraGanhosId, plataformaId},
  ];
  @override
  LeiturasGanhoPlataformaData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeiturasGanhoPlataformaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      leituraGanhosId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}leitura_ganhos_id'],
      )!,
      plataformaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plataforma_id'],
      )!,
      valorAcumuladoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_acumulado_centavos'],
      )!,
      quantidadeViagensAcumulada: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantidade_viagens_acumulada'],
      )!,
    );
  }

  @override
  $LeiturasGanhoPlataformaTable createAlias(String alias) {
    return $LeiturasGanhoPlataformaTable(attachedDatabase, alias);
  }
}

class LeiturasGanhoPlataformaData extends DataClass
    implements Insertable<LeiturasGanhoPlataformaData> {
  final int id;
  final int leituraGanhosId;
  final int plataformaId;
  final int valorAcumuladoCentavos;
  final int quantidadeViagensAcumulada;
  const LeiturasGanhoPlataformaData({
    required this.id,
    required this.leituraGanhosId,
    required this.plataformaId,
    required this.valorAcumuladoCentavos,
    required this.quantidadeViagensAcumulada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['leitura_ganhos_id'] = Variable<int>(leituraGanhosId);
    map['plataforma_id'] = Variable<int>(plataformaId);
    map['valor_acumulado_centavos'] = Variable<int>(valorAcumuladoCentavos);
    map['quantidade_viagens_acumulada'] = Variable<int>(
      quantidadeViagensAcumulada,
    );
    return map;
  }

  LeiturasGanhoPlataformaCompanion toCompanion(bool nullToAbsent) {
    return LeiturasGanhoPlataformaCompanion(
      id: Value(id),
      leituraGanhosId: Value(leituraGanhosId),
      plataformaId: Value(plataformaId),
      valorAcumuladoCentavos: Value(valorAcumuladoCentavos),
      quantidadeViagensAcumulada: Value(quantidadeViagensAcumulada),
    );
  }

  factory LeiturasGanhoPlataformaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeiturasGanhoPlataformaData(
      id: serializer.fromJson<int>(json['id']),
      leituraGanhosId: serializer.fromJson<int>(json['leituraGanhosId']),
      plataformaId: serializer.fromJson<int>(json['plataformaId']),
      valorAcumuladoCentavos: serializer.fromJson<int>(
        json['valorAcumuladoCentavos'],
      ),
      quantidadeViagensAcumulada: serializer.fromJson<int>(
        json['quantidadeViagensAcumulada'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'leituraGanhosId': serializer.toJson<int>(leituraGanhosId),
      'plataformaId': serializer.toJson<int>(plataformaId),
      'valorAcumuladoCentavos': serializer.toJson<int>(valorAcumuladoCentavos),
      'quantidadeViagensAcumulada': serializer.toJson<int>(
        quantidadeViagensAcumulada,
      ),
    };
  }

  LeiturasGanhoPlataformaData copyWith({
    int? id,
    int? leituraGanhosId,
    int? plataformaId,
    int? valorAcumuladoCentavos,
    int? quantidadeViagensAcumulada,
  }) => LeiturasGanhoPlataformaData(
    id: id ?? this.id,
    leituraGanhosId: leituraGanhosId ?? this.leituraGanhosId,
    plataformaId: plataformaId ?? this.plataformaId,
    valorAcumuladoCentavos:
        valorAcumuladoCentavos ?? this.valorAcumuladoCentavos,
    quantidadeViagensAcumulada:
        quantidadeViagensAcumulada ?? this.quantidadeViagensAcumulada,
  );
  LeiturasGanhoPlataformaData copyWithCompanion(
    LeiturasGanhoPlataformaCompanion data,
  ) {
    return LeiturasGanhoPlataformaData(
      id: data.id.present ? data.id.value : this.id,
      leituraGanhosId: data.leituraGanhosId.present
          ? data.leituraGanhosId.value
          : this.leituraGanhosId,
      plataformaId: data.plataformaId.present
          ? data.plataformaId.value
          : this.plataformaId,
      valorAcumuladoCentavos: data.valorAcumuladoCentavos.present
          ? data.valorAcumuladoCentavos.value
          : this.valorAcumuladoCentavos,
      quantidadeViagensAcumulada: data.quantidadeViagensAcumulada.present
          ? data.quantidadeViagensAcumulada.value
          : this.quantidadeViagensAcumulada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeiturasGanhoPlataformaData(')
          ..write('id: $id, ')
          ..write('leituraGanhosId: $leituraGanhosId, ')
          ..write('plataformaId: $plataformaId, ')
          ..write('valorAcumuladoCentavos: $valorAcumuladoCentavos, ')
          ..write('quantidadeViagensAcumulada: $quantidadeViagensAcumulada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    leituraGanhosId,
    plataformaId,
    valorAcumuladoCentavos,
    quantidadeViagensAcumulada,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeiturasGanhoPlataformaData &&
          other.id == this.id &&
          other.leituraGanhosId == this.leituraGanhosId &&
          other.plataformaId == this.plataformaId &&
          other.valorAcumuladoCentavos == this.valorAcumuladoCentavos &&
          other.quantidadeViagensAcumulada == this.quantidadeViagensAcumulada);
}

class LeiturasGanhoPlataformaCompanion
    extends UpdateCompanion<LeiturasGanhoPlataformaData> {
  final Value<int> id;
  final Value<int> leituraGanhosId;
  final Value<int> plataformaId;
  final Value<int> valorAcumuladoCentavos;
  final Value<int> quantidadeViagensAcumulada;
  const LeiturasGanhoPlataformaCompanion({
    this.id = const Value.absent(),
    this.leituraGanhosId = const Value.absent(),
    this.plataformaId = const Value.absent(),
    this.valorAcumuladoCentavos = const Value.absent(),
    this.quantidadeViagensAcumulada = const Value.absent(),
  });
  LeiturasGanhoPlataformaCompanion.insert({
    this.id = const Value.absent(),
    required int leituraGanhosId,
    required int plataformaId,
    required int valorAcumuladoCentavos,
    required int quantidadeViagensAcumulada,
  }) : leituraGanhosId = Value(leituraGanhosId),
       plataformaId = Value(plataformaId),
       valorAcumuladoCentavos = Value(valorAcumuladoCentavos),
       quantidadeViagensAcumulada = Value(quantidadeViagensAcumulada);
  static Insertable<LeiturasGanhoPlataformaData> custom({
    Expression<int>? id,
    Expression<int>? leituraGanhosId,
    Expression<int>? plataformaId,
    Expression<int>? valorAcumuladoCentavos,
    Expression<int>? quantidadeViagensAcumulada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (leituraGanhosId != null) 'leitura_ganhos_id': leituraGanhosId,
      if (plataformaId != null) 'plataforma_id': plataformaId,
      if (valorAcumuladoCentavos != null)
        'valor_acumulado_centavos': valorAcumuladoCentavos,
      if (quantidadeViagensAcumulada != null)
        'quantidade_viagens_acumulada': quantidadeViagensAcumulada,
    });
  }

  LeiturasGanhoPlataformaCompanion copyWith({
    Value<int>? id,
    Value<int>? leituraGanhosId,
    Value<int>? plataformaId,
    Value<int>? valorAcumuladoCentavos,
    Value<int>? quantidadeViagensAcumulada,
  }) {
    return LeiturasGanhoPlataformaCompanion(
      id: id ?? this.id,
      leituraGanhosId: leituraGanhosId ?? this.leituraGanhosId,
      plataformaId: plataformaId ?? this.plataformaId,
      valorAcumuladoCentavos:
          valorAcumuladoCentavos ?? this.valorAcumuladoCentavos,
      quantidadeViagensAcumulada:
          quantidadeViagensAcumulada ?? this.quantidadeViagensAcumulada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (leituraGanhosId.present) {
      map['leitura_ganhos_id'] = Variable<int>(leituraGanhosId.value);
    }
    if (plataformaId.present) {
      map['plataforma_id'] = Variable<int>(plataformaId.value);
    }
    if (valorAcumuladoCentavos.present) {
      map['valor_acumulado_centavos'] = Variable<int>(
        valorAcumuladoCentavos.value,
      );
    }
    if (quantidadeViagensAcumulada.present) {
      map['quantidade_viagens_acumulada'] = Variable<int>(
        quantidadeViagensAcumulada.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeiturasGanhoPlataformaCompanion(')
          ..write('id: $id, ')
          ..write('leituraGanhosId: $leituraGanhosId, ')
          ..write('plataformaId: $plataformaId, ')
          ..write('valorAcumuladoCentavos: $valorAcumuladoCentavos, ')
          ..write('quantidadeViagensAcumulada: $quantidadeViagensAcumulada')
          ..write(')'))
        .toString();
  }
}

class $LancamentosGanhoIndividualTable extends LancamentosGanhoIndividual
    with
        TableInfo<
          $LancamentosGanhoIndividualTable,
          LancamentosGanhoIndividualData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LancamentosGanhoIndividualTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _jornadaIdMeta = const VerificationMeta(
    'jornadaId',
  );
  @override
  late final GeneratedColumn<int> jornadaId = GeneratedColumn<int>(
    'jornada_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jornadas (id)',
    ),
  );
  static const VerificationMeta _quantidadeViagensMeta = const VerificationMeta(
    'quantidadeViagens',
  );
  @override
  late final GeneratedColumn<int> quantidadeViagens = GeneratedColumn<int>(
    'quantidade_viagens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorTotalCentavosMeta =
      const VerificationMeta('valorTotalCentavos');
  @override
  late final GeneratedColumn<int> valorTotalCentavos = GeneratedColumn<int>(
    'valor_total_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    plataformaId,
    jornadaId,
    quantidadeViagens,
    valorTotalCentavos,
    observacao,
    dataCriacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lancamentos_ganho_individual';
  @override
  VerificationContext validateIntegrity(
    Insertable<LancamentosGanhoIndividualData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('jornada_id')) {
      context.handle(
        _jornadaIdMeta,
        jornadaId.isAcceptableOrUnknown(data['jornada_id']!, _jornadaIdMeta),
      );
    }
    if (data.containsKey('quantidade_viagens')) {
      context.handle(
        _quantidadeViagensMeta,
        quantidadeViagens.isAcceptableOrUnknown(
          data['quantidade_viagens']!,
          _quantidadeViagensMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantidadeViagensMeta);
    }
    if (data.containsKey('valor_total_centavos')) {
      context.handle(
        _valorTotalCentavosMeta,
        valorTotalCentavos.isAcceptableOrUnknown(
          data['valor_total_centavos']!,
          _valorTotalCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorTotalCentavosMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LancamentosGanhoIndividualData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LancamentosGanhoIndividualData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      plataformaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plataforma_id'],
      )!,
      jornadaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jornada_id'],
      ),
      quantidadeViagens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantidade_viagens'],
      )!,
      valorTotalCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_total_centavos'],
      )!,
      observacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacao'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
    );
  }

  @override
  $LancamentosGanhoIndividualTable createAlias(String alias) {
    return $LancamentosGanhoIndividualTable(attachedDatabase, alias);
  }
}

class LancamentosGanhoIndividualData extends DataClass
    implements Insertable<LancamentosGanhoIndividualData> {
  final int id;
  final int plataformaId;
  final int? jornadaId;
  final int quantidadeViagens;
  final int valorTotalCentavos;
  final String? observacao;
  final DateTime dataCriacao;
  const LancamentosGanhoIndividualData({
    required this.id,
    required this.plataformaId,
    this.jornadaId,
    required this.quantidadeViagens,
    required this.valorTotalCentavos,
    this.observacao,
    required this.dataCriacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plataforma_id'] = Variable<int>(plataformaId);
    if (!nullToAbsent || jornadaId != null) {
      map['jornada_id'] = Variable<int>(jornadaId);
    }
    map['quantidade_viagens'] = Variable<int>(quantidadeViagens);
    map['valor_total_centavos'] = Variable<int>(valorTotalCentavos);
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    return map;
  }

  LancamentosGanhoIndividualCompanion toCompanion(bool nullToAbsent) {
    return LancamentosGanhoIndividualCompanion(
      id: Value(id),
      plataformaId: Value(plataformaId),
      jornadaId: jornadaId == null && nullToAbsent
          ? const Value.absent()
          : Value(jornadaId),
      quantidadeViagens: Value(quantidadeViagens),
      valorTotalCentavos: Value(valorTotalCentavos),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
      dataCriacao: Value(dataCriacao),
    );
  }

  factory LancamentosGanhoIndividualData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LancamentosGanhoIndividualData(
      id: serializer.fromJson<int>(json['id']),
      plataformaId: serializer.fromJson<int>(json['plataformaId']),
      jornadaId: serializer.fromJson<int?>(json['jornadaId']),
      quantidadeViagens: serializer.fromJson<int>(json['quantidadeViagens']),
      valorTotalCentavos: serializer.fromJson<int>(json['valorTotalCentavos']),
      observacao: serializer.fromJson<String?>(json['observacao']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plataformaId': serializer.toJson<int>(plataformaId),
      'jornadaId': serializer.toJson<int?>(jornadaId),
      'quantidadeViagens': serializer.toJson<int>(quantidadeViagens),
      'valorTotalCentavos': serializer.toJson<int>(valorTotalCentavos),
      'observacao': serializer.toJson<String?>(observacao),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
    };
  }

  LancamentosGanhoIndividualData copyWith({
    int? id,
    int? plataformaId,
    Value<int?> jornadaId = const Value.absent(),
    int? quantidadeViagens,
    int? valorTotalCentavos,
    Value<String?> observacao = const Value.absent(),
    DateTime? dataCriacao,
  }) => LancamentosGanhoIndividualData(
    id: id ?? this.id,
    plataformaId: plataformaId ?? this.plataformaId,
    jornadaId: jornadaId.present ? jornadaId.value : this.jornadaId,
    quantidadeViagens: quantidadeViagens ?? this.quantidadeViagens,
    valorTotalCentavos: valorTotalCentavos ?? this.valorTotalCentavos,
    observacao: observacao.present ? observacao.value : this.observacao,
    dataCriacao: dataCriacao ?? this.dataCriacao,
  );
  LancamentosGanhoIndividualData copyWithCompanion(
    LancamentosGanhoIndividualCompanion data,
  ) {
    return LancamentosGanhoIndividualData(
      id: data.id.present ? data.id.value : this.id,
      plataformaId: data.plataformaId.present
          ? data.plataformaId.value
          : this.plataformaId,
      jornadaId: data.jornadaId.present ? data.jornadaId.value : this.jornadaId,
      quantidadeViagens: data.quantidadeViagens.present
          ? data.quantidadeViagens.value
          : this.quantidadeViagens,
      valorTotalCentavos: data.valorTotalCentavos.present
          ? data.valorTotalCentavos.value
          : this.valorTotalCentavos,
      observacao: data.observacao.present
          ? data.observacao.value
          : this.observacao,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LancamentosGanhoIndividualData(')
          ..write('id: $id, ')
          ..write('plataformaId: $plataformaId, ')
          ..write('jornadaId: $jornadaId, ')
          ..write('quantidadeViagens: $quantidadeViagens, ')
          ..write('valorTotalCentavos: $valorTotalCentavos, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    plataformaId,
    jornadaId,
    quantidadeViagens,
    valorTotalCentavos,
    observacao,
    dataCriacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LancamentosGanhoIndividualData &&
          other.id == this.id &&
          other.plataformaId == this.plataformaId &&
          other.jornadaId == this.jornadaId &&
          other.quantidadeViagens == this.quantidadeViagens &&
          other.valorTotalCentavos == this.valorTotalCentavos &&
          other.observacao == this.observacao &&
          other.dataCriacao == this.dataCriacao);
}

class LancamentosGanhoIndividualCompanion
    extends UpdateCompanion<LancamentosGanhoIndividualData> {
  final Value<int> id;
  final Value<int> plataformaId;
  final Value<int?> jornadaId;
  final Value<int> quantidadeViagens;
  final Value<int> valorTotalCentavos;
  final Value<String?> observacao;
  final Value<DateTime> dataCriacao;
  const LancamentosGanhoIndividualCompanion({
    this.id = const Value.absent(),
    this.plataformaId = const Value.absent(),
    this.jornadaId = const Value.absent(),
    this.quantidadeViagens = const Value.absent(),
    this.valorTotalCentavos = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  });
  LancamentosGanhoIndividualCompanion.insert({
    this.id = const Value.absent(),
    required int plataformaId,
    this.jornadaId = const Value.absent(),
    required int quantidadeViagens,
    required int valorTotalCentavos,
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  }) : plataformaId = Value(plataformaId),
       quantidadeViagens = Value(quantidadeViagens),
       valorTotalCentavos = Value(valorTotalCentavos);
  static Insertable<LancamentosGanhoIndividualData> custom({
    Expression<int>? id,
    Expression<int>? plataformaId,
    Expression<int>? jornadaId,
    Expression<int>? quantidadeViagens,
    Expression<int>? valorTotalCentavos,
    Expression<String>? observacao,
    Expression<DateTime>? dataCriacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plataformaId != null) 'plataforma_id': plataformaId,
      if (jornadaId != null) 'jornada_id': jornadaId,
      if (quantidadeViagens != null) 'quantidade_viagens': quantidadeViagens,
      if (valorTotalCentavos != null)
        'valor_total_centavos': valorTotalCentavos,
      if (observacao != null) 'observacao': observacao,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
    });
  }

  LancamentosGanhoIndividualCompanion copyWith({
    Value<int>? id,
    Value<int>? plataformaId,
    Value<int?>? jornadaId,
    Value<int>? quantidadeViagens,
    Value<int>? valorTotalCentavos,
    Value<String?>? observacao,
    Value<DateTime>? dataCriacao,
  }) {
    return LancamentosGanhoIndividualCompanion(
      id: id ?? this.id,
      plataformaId: plataformaId ?? this.plataformaId,
      jornadaId: jornadaId ?? this.jornadaId,
      quantidadeViagens: quantidadeViagens ?? this.quantidadeViagens,
      valorTotalCentavos: valorTotalCentavos ?? this.valorTotalCentavos,
      observacao: observacao ?? this.observacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plataformaId.present) {
      map['plataforma_id'] = Variable<int>(plataformaId.value);
    }
    if (jornadaId.present) {
      map['jornada_id'] = Variable<int>(jornadaId.value);
    }
    if (quantidadeViagens.present) {
      map['quantidade_viagens'] = Variable<int>(quantidadeViagens.value);
    }
    if (valorTotalCentavos.present) {
      map['valor_total_centavos'] = Variable<int>(valorTotalCentavos.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LancamentosGanhoIndividualCompanion(')
          ..write('id: $id, ')
          ..write('plataformaId: $plataformaId, ')
          ..write('jornadaId: $jornadaId, ')
          ..write('quantidadeViagens: $quantidadeViagens, ')
          ..write('valorTotalCentavos: $valorTotalCentavos, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }
}

class $AbastecimentosTable extends Abastecimentos
    with TableInfo<$AbastecimentosTable, Abastecimento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AbastecimentosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _jornadaIdMeta = const VerificationMeta(
    'jornadaId',
  );
  @override
  late final GeneratedColumn<int> jornadaId = GeneratedColumn<int>(
    'jornada_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jornadas (id)',
    ),
  );
  static const VerificationMeta _dataHoraMeta = const VerificationMeta(
    'dataHora',
  );
  @override
  late final GeneratedColumn<DateTime> dataHora = GeneratedColumn<DateTime>(
    'data_hora',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometroMeta = const VerificationMeta(
    'odometro',
  );
  @override
  late final GeneratedColumn<int> odometro = GeneratedColumn<int>(
    'odometro',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoCombustivel, String>
  tipoCombustivel =
      GeneratedColumn<String>(
        'tipo_combustivel',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoCombustivel>(
        $AbastecimentosTable.$convertertipoCombustivel,
      );
  static const VerificationMeta _volumeMililitrosMeta = const VerificationMeta(
    'volumeMililitros',
  );
  @override
  late final GeneratedColumn<int> volumeMililitros = GeneratedColumn<int>(
    'volume_mililitros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorTotalPagoCentavosMeta =
      const VerificationMeta('valorTotalPagoCentavos');
  @override
  late final GeneratedColumn<int> valorTotalPagoCentavos = GeneratedColumn<int>(
    'valor_total_pago_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precoBombaMilesimosRealPorLitroMeta =
      const VerificationMeta('precoBombaMilesimosRealPorLitro');
  @override
  late final GeneratedColumn<int> precoBombaMilesimosRealPorLitro =
      GeneratedColumn<int>(
        'preco_bomba_milesimos_real_por_litro',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _tanqueCheioMeta = const VerificationMeta(
    'tanqueCheio',
  );
  @override
  late final GeneratedColumn<bool> tanqueCheio = GeneratedColumn<bool>(
    'tanque_cheio',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tanque_cheio" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _cidadeMeta = const VerificationMeta('cidade');
  @override
  late final GeneratedColumn<String> cidade = GeneratedColumn<String>(
    'cidade',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nomePostoMeta = const VerificationMeta(
    'nomePosto',
  );
  @override
  late final GeneratedColumn<String> nomePosto = GeneratedColumn<String>(
    'nome_posto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bandeiraPostoMeta = const VerificationMeta(
    'bandeiraPosto',
  );
  @override
  late final GeneratedColumn<String> bandeiraPosto = GeneratedColumn<String>(
    'bandeira_posto',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    veiculoId,
    jornadaId,
    dataHora,
    odometro,
    tipoCombustivel,
    volumeMililitros,
    valorTotalPagoCentavos,
    precoBombaMilesimosRealPorLitro,
    tanqueCheio,
    cidade,
    nomePosto,
    bandeiraPosto,
    observacao,
    dataCriacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'abastecimentos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Abastecimento> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('veiculo_id')) {
      context.handle(
        _veiculoIdMeta,
        veiculoId.isAcceptableOrUnknown(data['veiculo_id']!, _veiculoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_veiculoIdMeta);
    }
    if (data.containsKey('jornada_id')) {
      context.handle(
        _jornadaIdMeta,
        jornadaId.isAcceptableOrUnknown(data['jornada_id']!, _jornadaIdMeta),
      );
    }
    if (data.containsKey('data_hora')) {
      context.handle(
        _dataHoraMeta,
        dataHora.isAcceptableOrUnknown(data['data_hora']!, _dataHoraMeta),
      );
    } else if (isInserting) {
      context.missing(_dataHoraMeta);
    }
    if (data.containsKey('odometro')) {
      context.handle(
        _odometroMeta,
        odometro.isAcceptableOrUnknown(data['odometro']!, _odometroMeta),
      );
    } else if (isInserting) {
      context.missing(_odometroMeta);
    }
    if (data.containsKey('volume_mililitros')) {
      context.handle(
        _volumeMililitrosMeta,
        volumeMililitros.isAcceptableOrUnknown(
          data['volume_mililitros']!,
          _volumeMililitrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_volumeMililitrosMeta);
    }
    if (data.containsKey('valor_total_pago_centavos')) {
      context.handle(
        _valorTotalPagoCentavosMeta,
        valorTotalPagoCentavos.isAcceptableOrUnknown(
          data['valor_total_pago_centavos']!,
          _valorTotalPagoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorTotalPagoCentavosMeta);
    }
    if (data.containsKey('preco_bomba_milesimos_real_por_litro')) {
      context.handle(
        _precoBombaMilesimosRealPorLitroMeta,
        precoBombaMilesimosRealPorLitro.isAcceptableOrUnknown(
          data['preco_bomba_milesimos_real_por_litro']!,
          _precoBombaMilesimosRealPorLitroMeta,
        ),
      );
    }
    if (data.containsKey('tanque_cheio')) {
      context.handle(
        _tanqueCheioMeta,
        tanqueCheio.isAcceptableOrUnknown(
          data['tanque_cheio']!,
          _tanqueCheioMeta,
        ),
      );
    }
    if (data.containsKey('cidade')) {
      context.handle(
        _cidadeMeta,
        cidade.isAcceptableOrUnknown(data['cidade']!, _cidadeMeta),
      );
    }
    if (data.containsKey('nome_posto')) {
      context.handle(
        _nomePostoMeta,
        nomePosto.isAcceptableOrUnknown(data['nome_posto']!, _nomePostoMeta),
      );
    }
    if (data.containsKey('bandeira_posto')) {
      context.handle(
        _bandeiraPostoMeta,
        bandeiraPosto.isAcceptableOrUnknown(
          data['bandeira_posto']!,
          _bandeiraPostoMeta,
        ),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Abastecimento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Abastecimento(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      veiculoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}veiculo_id'],
      )!,
      jornadaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jornada_id'],
      ),
      dataHora: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora'],
      )!,
      odometro: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odometro'],
      )!,
      tipoCombustivel: $AbastecimentosTable.$convertertipoCombustivel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo_combustivel'],
        )!,
      ),
      volumeMililitros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}volume_mililitros'],
      )!,
      valorTotalPagoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_total_pago_centavos'],
      )!,
      precoBombaMilesimosRealPorLitro: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preco_bomba_milesimos_real_por_litro'],
      ),
      tanqueCheio: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tanque_cheio'],
      )!,
      cidade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cidade'],
      ),
      nomePosto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_posto'],
      ),
      bandeiraPosto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bandeira_posto'],
      ),
      observacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacao'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
    );
  }

  @override
  $AbastecimentosTable createAlias(String alias) {
    return $AbastecimentosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoCombustivel, String, String>
  $convertertipoCombustivel = const EnumNameConverter<TipoCombustivel>(
    TipoCombustivel.values,
  );
}

class Abastecimento extends DataClass implements Insertable<Abastecimento> {
  final int id;
  final int veiculoId;
  final int? jornadaId;
  final DateTime dataHora;
  final int odometro;
  final TipoCombustivel tipoCombustivel;
  final int volumeMililitros;
  final int valorTotalPagoCentavos;
  final int? precoBombaMilesimosRealPorLitro;
  final bool tanqueCheio;
  final String? cidade;
  final String? nomePosto;
  final String? bandeiraPosto;
  final String? observacao;
  final DateTime dataCriacao;
  const Abastecimento({
    required this.id,
    required this.veiculoId,
    this.jornadaId,
    required this.dataHora,
    required this.odometro,
    required this.tipoCombustivel,
    required this.volumeMililitros,
    required this.valorTotalPagoCentavos,
    this.precoBombaMilesimosRealPorLitro,
    required this.tanqueCheio,
    this.cidade,
    this.nomePosto,
    this.bandeiraPosto,
    this.observacao,
    required this.dataCriacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['veiculo_id'] = Variable<int>(veiculoId);
    if (!nullToAbsent || jornadaId != null) {
      map['jornada_id'] = Variable<int>(jornadaId);
    }
    map['data_hora'] = Variable<DateTime>(dataHora);
    map['odometro'] = Variable<int>(odometro);
    {
      map['tipo_combustivel'] = Variable<String>(
        $AbastecimentosTable.$convertertipoCombustivel.toSql(tipoCombustivel),
      );
    }
    map['volume_mililitros'] = Variable<int>(volumeMililitros);
    map['valor_total_pago_centavos'] = Variable<int>(valorTotalPagoCentavos);
    if (!nullToAbsent || precoBombaMilesimosRealPorLitro != null) {
      map['preco_bomba_milesimos_real_por_litro'] = Variable<int>(
        precoBombaMilesimosRealPorLitro,
      );
    }
    map['tanque_cheio'] = Variable<bool>(tanqueCheio);
    if (!nullToAbsent || cidade != null) {
      map['cidade'] = Variable<String>(cidade);
    }
    if (!nullToAbsent || nomePosto != null) {
      map['nome_posto'] = Variable<String>(nomePosto);
    }
    if (!nullToAbsent || bandeiraPosto != null) {
      map['bandeira_posto'] = Variable<String>(bandeiraPosto);
    }
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    return map;
  }

  AbastecimentosCompanion toCompanion(bool nullToAbsent) {
    return AbastecimentosCompanion(
      id: Value(id),
      veiculoId: Value(veiculoId),
      jornadaId: jornadaId == null && nullToAbsent
          ? const Value.absent()
          : Value(jornadaId),
      dataHora: Value(dataHora),
      odometro: Value(odometro),
      tipoCombustivel: Value(tipoCombustivel),
      volumeMililitros: Value(volumeMililitros),
      valorTotalPagoCentavos: Value(valorTotalPagoCentavos),
      precoBombaMilesimosRealPorLitro:
          precoBombaMilesimosRealPorLitro == null && nullToAbsent
          ? const Value.absent()
          : Value(precoBombaMilesimosRealPorLitro),
      tanqueCheio: Value(tanqueCheio),
      cidade: cidade == null && nullToAbsent
          ? const Value.absent()
          : Value(cidade),
      nomePosto: nomePosto == null && nullToAbsent
          ? const Value.absent()
          : Value(nomePosto),
      bandeiraPosto: bandeiraPosto == null && nullToAbsent
          ? const Value.absent()
          : Value(bandeiraPosto),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
      dataCriacao: Value(dataCriacao),
    );
  }

  factory Abastecimento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Abastecimento(
      id: serializer.fromJson<int>(json['id']),
      veiculoId: serializer.fromJson<int>(json['veiculoId']),
      jornadaId: serializer.fromJson<int?>(json['jornadaId']),
      dataHora: serializer.fromJson<DateTime>(json['dataHora']),
      odometro: serializer.fromJson<int>(json['odometro']),
      tipoCombustivel: $AbastecimentosTable.$convertertipoCombustivel.fromJson(
        serializer.fromJson<String>(json['tipoCombustivel']),
      ),
      volumeMililitros: serializer.fromJson<int>(json['volumeMililitros']),
      valorTotalPagoCentavos: serializer.fromJson<int>(
        json['valorTotalPagoCentavos'],
      ),
      precoBombaMilesimosRealPorLitro: serializer.fromJson<int?>(
        json['precoBombaMilesimosRealPorLitro'],
      ),
      tanqueCheio: serializer.fromJson<bool>(json['tanqueCheio']),
      cidade: serializer.fromJson<String?>(json['cidade']),
      nomePosto: serializer.fromJson<String?>(json['nomePosto']),
      bandeiraPosto: serializer.fromJson<String?>(json['bandeiraPosto']),
      observacao: serializer.fromJson<String?>(json['observacao']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'veiculoId': serializer.toJson<int>(veiculoId),
      'jornadaId': serializer.toJson<int?>(jornadaId),
      'dataHora': serializer.toJson<DateTime>(dataHora),
      'odometro': serializer.toJson<int>(odometro),
      'tipoCombustivel': serializer.toJson<String>(
        $AbastecimentosTable.$convertertipoCombustivel.toJson(tipoCombustivel),
      ),
      'volumeMililitros': serializer.toJson<int>(volumeMililitros),
      'valorTotalPagoCentavos': serializer.toJson<int>(valorTotalPagoCentavos),
      'precoBombaMilesimosRealPorLitro': serializer.toJson<int?>(
        precoBombaMilesimosRealPorLitro,
      ),
      'tanqueCheio': serializer.toJson<bool>(tanqueCheio),
      'cidade': serializer.toJson<String?>(cidade),
      'nomePosto': serializer.toJson<String?>(nomePosto),
      'bandeiraPosto': serializer.toJson<String?>(bandeiraPosto),
      'observacao': serializer.toJson<String?>(observacao),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
    };
  }

  Abastecimento copyWith({
    int? id,
    int? veiculoId,
    Value<int?> jornadaId = const Value.absent(),
    DateTime? dataHora,
    int? odometro,
    TipoCombustivel? tipoCombustivel,
    int? volumeMililitros,
    int? valorTotalPagoCentavos,
    Value<int?> precoBombaMilesimosRealPorLitro = const Value.absent(),
    bool? tanqueCheio,
    Value<String?> cidade = const Value.absent(),
    Value<String?> nomePosto = const Value.absent(),
    Value<String?> bandeiraPosto = const Value.absent(),
    Value<String?> observacao = const Value.absent(),
    DateTime? dataCriacao,
  }) => Abastecimento(
    id: id ?? this.id,
    veiculoId: veiculoId ?? this.veiculoId,
    jornadaId: jornadaId.present ? jornadaId.value : this.jornadaId,
    dataHora: dataHora ?? this.dataHora,
    odometro: odometro ?? this.odometro,
    tipoCombustivel: tipoCombustivel ?? this.tipoCombustivel,
    volumeMililitros: volumeMililitros ?? this.volumeMililitros,
    valorTotalPagoCentavos:
        valorTotalPagoCentavos ?? this.valorTotalPagoCentavos,
    precoBombaMilesimosRealPorLitro: precoBombaMilesimosRealPorLitro.present
        ? precoBombaMilesimosRealPorLitro.value
        : this.precoBombaMilesimosRealPorLitro,
    tanqueCheio: tanqueCheio ?? this.tanqueCheio,
    cidade: cidade.present ? cidade.value : this.cidade,
    nomePosto: nomePosto.present ? nomePosto.value : this.nomePosto,
    bandeiraPosto: bandeiraPosto.present
        ? bandeiraPosto.value
        : this.bandeiraPosto,
    observacao: observacao.present ? observacao.value : this.observacao,
    dataCriacao: dataCriacao ?? this.dataCriacao,
  );
  Abastecimento copyWithCompanion(AbastecimentosCompanion data) {
    return Abastecimento(
      id: data.id.present ? data.id.value : this.id,
      veiculoId: data.veiculoId.present ? data.veiculoId.value : this.veiculoId,
      jornadaId: data.jornadaId.present ? data.jornadaId.value : this.jornadaId,
      dataHora: data.dataHora.present ? data.dataHora.value : this.dataHora,
      odometro: data.odometro.present ? data.odometro.value : this.odometro,
      tipoCombustivel: data.tipoCombustivel.present
          ? data.tipoCombustivel.value
          : this.tipoCombustivel,
      volumeMililitros: data.volumeMililitros.present
          ? data.volumeMililitros.value
          : this.volumeMililitros,
      valorTotalPagoCentavos: data.valorTotalPagoCentavos.present
          ? data.valorTotalPagoCentavos.value
          : this.valorTotalPagoCentavos,
      precoBombaMilesimosRealPorLitro:
          data.precoBombaMilesimosRealPorLitro.present
          ? data.precoBombaMilesimosRealPorLitro.value
          : this.precoBombaMilesimosRealPorLitro,
      tanqueCheio: data.tanqueCheio.present
          ? data.tanqueCheio.value
          : this.tanqueCheio,
      cidade: data.cidade.present ? data.cidade.value : this.cidade,
      nomePosto: data.nomePosto.present ? data.nomePosto.value : this.nomePosto,
      bandeiraPosto: data.bandeiraPosto.present
          ? data.bandeiraPosto.value
          : this.bandeiraPosto,
      observacao: data.observacao.present
          ? data.observacao.value
          : this.observacao,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Abastecimento(')
          ..write('id: $id, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('jornadaId: $jornadaId, ')
          ..write('dataHora: $dataHora, ')
          ..write('odometro: $odometro, ')
          ..write('tipoCombustivel: $tipoCombustivel, ')
          ..write('volumeMililitros: $volumeMililitros, ')
          ..write('valorTotalPagoCentavos: $valorTotalPagoCentavos, ')
          ..write(
            'precoBombaMilesimosRealPorLitro: $precoBombaMilesimosRealPorLitro, ',
          )
          ..write('tanqueCheio: $tanqueCheio, ')
          ..write('cidade: $cidade, ')
          ..write('nomePosto: $nomePosto, ')
          ..write('bandeiraPosto: $bandeiraPosto, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    veiculoId,
    jornadaId,
    dataHora,
    odometro,
    tipoCombustivel,
    volumeMililitros,
    valorTotalPagoCentavos,
    precoBombaMilesimosRealPorLitro,
    tanqueCheio,
    cidade,
    nomePosto,
    bandeiraPosto,
    observacao,
    dataCriacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Abastecimento &&
          other.id == this.id &&
          other.veiculoId == this.veiculoId &&
          other.jornadaId == this.jornadaId &&
          other.dataHora == this.dataHora &&
          other.odometro == this.odometro &&
          other.tipoCombustivel == this.tipoCombustivel &&
          other.volumeMililitros == this.volumeMililitros &&
          other.valorTotalPagoCentavos == this.valorTotalPagoCentavos &&
          other.precoBombaMilesimosRealPorLitro ==
              this.precoBombaMilesimosRealPorLitro &&
          other.tanqueCheio == this.tanqueCheio &&
          other.cidade == this.cidade &&
          other.nomePosto == this.nomePosto &&
          other.bandeiraPosto == this.bandeiraPosto &&
          other.observacao == this.observacao &&
          other.dataCriacao == this.dataCriacao);
}

class AbastecimentosCompanion extends UpdateCompanion<Abastecimento> {
  final Value<int> id;
  final Value<int> veiculoId;
  final Value<int?> jornadaId;
  final Value<DateTime> dataHora;
  final Value<int> odometro;
  final Value<TipoCombustivel> tipoCombustivel;
  final Value<int> volumeMililitros;
  final Value<int> valorTotalPagoCentavos;
  final Value<int?> precoBombaMilesimosRealPorLitro;
  final Value<bool> tanqueCheio;
  final Value<String?> cidade;
  final Value<String?> nomePosto;
  final Value<String?> bandeiraPosto;
  final Value<String?> observacao;
  final Value<DateTime> dataCriacao;
  const AbastecimentosCompanion({
    this.id = const Value.absent(),
    this.veiculoId = const Value.absent(),
    this.jornadaId = const Value.absent(),
    this.dataHora = const Value.absent(),
    this.odometro = const Value.absent(),
    this.tipoCombustivel = const Value.absent(),
    this.volumeMililitros = const Value.absent(),
    this.valorTotalPagoCentavos = const Value.absent(),
    this.precoBombaMilesimosRealPorLitro = const Value.absent(),
    this.tanqueCheio = const Value.absent(),
    this.cidade = const Value.absent(),
    this.nomePosto = const Value.absent(),
    this.bandeiraPosto = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  });
  AbastecimentosCompanion.insert({
    this.id = const Value.absent(),
    required int veiculoId,
    this.jornadaId = const Value.absent(),
    required DateTime dataHora,
    required int odometro,
    required TipoCombustivel tipoCombustivel,
    required int volumeMililitros,
    required int valorTotalPagoCentavos,
    this.precoBombaMilesimosRealPorLitro = const Value.absent(),
    this.tanqueCheio = const Value.absent(),
    this.cidade = const Value.absent(),
    this.nomePosto = const Value.absent(),
    this.bandeiraPosto = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  }) : veiculoId = Value(veiculoId),
       dataHora = Value(dataHora),
       odometro = Value(odometro),
       tipoCombustivel = Value(tipoCombustivel),
       volumeMililitros = Value(volumeMililitros),
       valorTotalPagoCentavos = Value(valorTotalPagoCentavos);
  static Insertable<Abastecimento> custom({
    Expression<int>? id,
    Expression<int>? veiculoId,
    Expression<int>? jornadaId,
    Expression<DateTime>? dataHora,
    Expression<int>? odometro,
    Expression<String>? tipoCombustivel,
    Expression<int>? volumeMililitros,
    Expression<int>? valorTotalPagoCentavos,
    Expression<int>? precoBombaMilesimosRealPorLitro,
    Expression<bool>? tanqueCheio,
    Expression<String>? cidade,
    Expression<String>? nomePosto,
    Expression<String>? bandeiraPosto,
    Expression<String>? observacao,
    Expression<DateTime>? dataCriacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (veiculoId != null) 'veiculo_id': veiculoId,
      if (jornadaId != null) 'jornada_id': jornadaId,
      if (dataHora != null) 'data_hora': dataHora,
      if (odometro != null) 'odometro': odometro,
      if (tipoCombustivel != null) 'tipo_combustivel': tipoCombustivel,
      if (volumeMililitros != null) 'volume_mililitros': volumeMililitros,
      if (valorTotalPagoCentavos != null)
        'valor_total_pago_centavos': valorTotalPagoCentavos,
      if (precoBombaMilesimosRealPorLitro != null)
        'preco_bomba_milesimos_real_por_litro': precoBombaMilesimosRealPorLitro,
      if (tanqueCheio != null) 'tanque_cheio': tanqueCheio,
      if (cidade != null) 'cidade': cidade,
      if (nomePosto != null) 'nome_posto': nomePosto,
      if (bandeiraPosto != null) 'bandeira_posto': bandeiraPosto,
      if (observacao != null) 'observacao': observacao,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
    });
  }

  AbastecimentosCompanion copyWith({
    Value<int>? id,
    Value<int>? veiculoId,
    Value<int?>? jornadaId,
    Value<DateTime>? dataHora,
    Value<int>? odometro,
    Value<TipoCombustivel>? tipoCombustivel,
    Value<int>? volumeMililitros,
    Value<int>? valorTotalPagoCentavos,
    Value<int?>? precoBombaMilesimosRealPorLitro,
    Value<bool>? tanqueCheio,
    Value<String?>? cidade,
    Value<String?>? nomePosto,
    Value<String?>? bandeiraPosto,
    Value<String?>? observacao,
    Value<DateTime>? dataCriacao,
  }) {
    return AbastecimentosCompanion(
      id: id ?? this.id,
      veiculoId: veiculoId ?? this.veiculoId,
      jornadaId: jornadaId ?? this.jornadaId,
      dataHora: dataHora ?? this.dataHora,
      odometro: odometro ?? this.odometro,
      tipoCombustivel: tipoCombustivel ?? this.tipoCombustivel,
      volumeMililitros: volumeMililitros ?? this.volumeMililitros,
      valorTotalPagoCentavos:
          valorTotalPagoCentavos ?? this.valorTotalPagoCentavos,
      precoBombaMilesimosRealPorLitro:
          precoBombaMilesimosRealPorLitro ??
          this.precoBombaMilesimosRealPorLitro,
      tanqueCheio: tanqueCheio ?? this.tanqueCheio,
      cidade: cidade ?? this.cidade,
      nomePosto: nomePosto ?? this.nomePosto,
      bandeiraPosto: bandeiraPosto ?? this.bandeiraPosto,
      observacao: observacao ?? this.observacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (veiculoId.present) {
      map['veiculo_id'] = Variable<int>(veiculoId.value);
    }
    if (jornadaId.present) {
      map['jornada_id'] = Variable<int>(jornadaId.value);
    }
    if (dataHora.present) {
      map['data_hora'] = Variable<DateTime>(dataHora.value);
    }
    if (odometro.present) {
      map['odometro'] = Variable<int>(odometro.value);
    }
    if (tipoCombustivel.present) {
      map['tipo_combustivel'] = Variable<String>(
        $AbastecimentosTable.$convertertipoCombustivel.toSql(
          tipoCombustivel.value,
        ),
      );
    }
    if (volumeMililitros.present) {
      map['volume_mililitros'] = Variable<int>(volumeMililitros.value);
    }
    if (valorTotalPagoCentavos.present) {
      map['valor_total_pago_centavos'] = Variable<int>(
        valorTotalPagoCentavos.value,
      );
    }
    if (precoBombaMilesimosRealPorLitro.present) {
      map['preco_bomba_milesimos_real_por_litro'] = Variable<int>(
        precoBombaMilesimosRealPorLitro.value,
      );
    }
    if (tanqueCheio.present) {
      map['tanque_cheio'] = Variable<bool>(tanqueCheio.value);
    }
    if (cidade.present) {
      map['cidade'] = Variable<String>(cidade.value);
    }
    if (nomePosto.present) {
      map['nome_posto'] = Variable<String>(nomePosto.value);
    }
    if (bandeiraPosto.present) {
      map['bandeira_posto'] = Variable<String>(bandeiraPosto.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AbastecimentosCompanion(')
          ..write('id: $id, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('jornadaId: $jornadaId, ')
          ..write('dataHora: $dataHora, ')
          ..write('odometro: $odometro, ')
          ..write('tipoCombustivel: $tipoCombustivel, ')
          ..write('volumeMililitros: $volumeMililitros, ')
          ..write('valorTotalPagoCentavos: $valorTotalPagoCentavos, ')
          ..write(
            'precoBombaMilesimosRealPorLitro: $precoBombaMilesimosRealPorLitro, ',
          )
          ..write('tanqueCheio: $tanqueCheio, ')
          ..write('cidade: $cidade, ')
          ..write('nomePosto: $nomePosto, ')
          ..write('bandeiraPosto: $bandeiraPosto, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }
}

class $PassesPlataformaTable extends PassesPlataforma
    with TableInfo<$PassesPlataformaTable, PassesPlataformaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PassesPlataformaTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _jornadaIdMeta = const VerificationMeta(
    'jornadaId',
  );
  @override
  late final GeneratedColumn<int> jornadaId = GeneratedColumn<int>(
    'jornada_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jornadas (id)',
    ),
  );
  static const VerificationMeta _dataHoraMeta = const VerificationMeta(
    'dataHora',
  );
  @override
  late final GeneratedColumn<DateTime> dataHora = GeneratedColumn<DateTime>(
    'data_hora',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorPagoCentavosMeta = const VerificationMeta(
    'valorPagoCentavos',
  );
  @override
  late final GeneratedColumn<int> valorPagoCentavos = GeneratedColumn<int>(
    'valor_pago_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modalidadeMeta = const VerificationMeta(
    'modalidade',
  );
  @override
  late final GeneratedColumn<String> modalidade = GeneratedColumn<String>(
    'modalidade',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validadeAteMeta = const VerificationMeta(
    'validadeAte',
  );
  @override
  late final GeneratedColumn<DateTime> validadeAte = GeneratedColumn<DateTime>(
    'validade_ate',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _limiteFaturamentoCentavosMeta =
      const VerificationMeta('limiteFaturamentoCentavos');
  @override
  late final GeneratedColumn<int> limiteFaturamentoCentavos =
      GeneratedColumn<int>(
        'limite_faturamento_centavos',
        aliasedName,
        true,
        type: DriftSqlType.int,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    plataformaId,
    jornadaId,
    dataHora,
    valorPagoCentavos,
    modalidade,
    validadeAte,
    limiteFaturamentoCentavos,
    observacao,
    dataCriacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'passes_plataforma';
  @override
  VerificationContext validateIntegrity(
    Insertable<PassesPlataformaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('jornada_id')) {
      context.handle(
        _jornadaIdMeta,
        jornadaId.isAcceptableOrUnknown(data['jornada_id']!, _jornadaIdMeta),
      );
    }
    if (data.containsKey('data_hora')) {
      context.handle(
        _dataHoraMeta,
        dataHora.isAcceptableOrUnknown(data['data_hora']!, _dataHoraMeta),
      );
    } else if (isInserting) {
      context.missing(_dataHoraMeta);
    }
    if (data.containsKey('valor_pago_centavos')) {
      context.handle(
        _valorPagoCentavosMeta,
        valorPagoCentavos.isAcceptableOrUnknown(
          data['valor_pago_centavos']!,
          _valorPagoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorPagoCentavosMeta);
    }
    if (data.containsKey('modalidade')) {
      context.handle(
        _modalidadeMeta,
        modalidade.isAcceptableOrUnknown(data['modalidade']!, _modalidadeMeta),
      );
    }
    if (data.containsKey('validade_ate')) {
      context.handle(
        _validadeAteMeta,
        validadeAte.isAcceptableOrUnknown(
          data['validade_ate']!,
          _validadeAteMeta,
        ),
      );
    }
    if (data.containsKey('limite_faturamento_centavos')) {
      context.handle(
        _limiteFaturamentoCentavosMeta,
        limiteFaturamentoCentavos.isAcceptableOrUnknown(
          data['limite_faturamento_centavos']!,
          _limiteFaturamentoCentavosMeta,
        ),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PassesPlataformaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PassesPlataformaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      plataformaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plataforma_id'],
      )!,
      jornadaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jornada_id'],
      ),
      dataHora: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora'],
      )!,
      valorPagoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_pago_centavos'],
      )!,
      modalidade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modalidade'],
      ),
      validadeAte: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}validade_ate'],
      ),
      limiteFaturamentoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}limite_faturamento_centavos'],
      ),
      observacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacao'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
    );
  }

  @override
  $PassesPlataformaTable createAlias(String alias) {
    return $PassesPlataformaTable(attachedDatabase, alias);
  }
}

class PassesPlataformaData extends DataClass
    implements Insertable<PassesPlataformaData> {
  final int id;
  final int plataformaId;
  final int? jornadaId;
  final DateTime dataHora;
  final int valorPagoCentavos;
  final String? modalidade;
  final DateTime? validadeAte;
  final int? limiteFaturamentoCentavos;
  final String? observacao;
  final DateTime dataCriacao;
  const PassesPlataformaData({
    required this.id,
    required this.plataformaId,
    this.jornadaId,
    required this.dataHora,
    required this.valorPagoCentavos,
    this.modalidade,
    this.validadeAte,
    this.limiteFaturamentoCentavos,
    this.observacao,
    required this.dataCriacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plataforma_id'] = Variable<int>(plataformaId);
    if (!nullToAbsent || jornadaId != null) {
      map['jornada_id'] = Variable<int>(jornadaId);
    }
    map['data_hora'] = Variable<DateTime>(dataHora);
    map['valor_pago_centavos'] = Variable<int>(valorPagoCentavos);
    if (!nullToAbsent || modalidade != null) {
      map['modalidade'] = Variable<String>(modalidade);
    }
    if (!nullToAbsent || validadeAte != null) {
      map['validade_ate'] = Variable<DateTime>(validadeAte);
    }
    if (!nullToAbsent || limiteFaturamentoCentavos != null) {
      map['limite_faturamento_centavos'] = Variable<int>(
        limiteFaturamentoCentavos,
      );
    }
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    return map;
  }

  PassesPlataformaCompanion toCompanion(bool nullToAbsent) {
    return PassesPlataformaCompanion(
      id: Value(id),
      plataformaId: Value(plataformaId),
      jornadaId: jornadaId == null && nullToAbsent
          ? const Value.absent()
          : Value(jornadaId),
      dataHora: Value(dataHora),
      valorPagoCentavos: Value(valorPagoCentavos),
      modalidade: modalidade == null && nullToAbsent
          ? const Value.absent()
          : Value(modalidade),
      validadeAte: validadeAte == null && nullToAbsent
          ? const Value.absent()
          : Value(validadeAte),
      limiteFaturamentoCentavos:
          limiteFaturamentoCentavos == null && nullToAbsent
          ? const Value.absent()
          : Value(limiteFaturamentoCentavos),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
      dataCriacao: Value(dataCriacao),
    );
  }

  factory PassesPlataformaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PassesPlataformaData(
      id: serializer.fromJson<int>(json['id']),
      plataformaId: serializer.fromJson<int>(json['plataformaId']),
      jornadaId: serializer.fromJson<int?>(json['jornadaId']),
      dataHora: serializer.fromJson<DateTime>(json['dataHora']),
      valorPagoCentavos: serializer.fromJson<int>(json['valorPagoCentavos']),
      modalidade: serializer.fromJson<String?>(json['modalidade']),
      validadeAte: serializer.fromJson<DateTime?>(json['validadeAte']),
      limiteFaturamentoCentavos: serializer.fromJson<int?>(
        json['limiteFaturamentoCentavos'],
      ),
      observacao: serializer.fromJson<String?>(json['observacao']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plataformaId': serializer.toJson<int>(plataformaId),
      'jornadaId': serializer.toJson<int?>(jornadaId),
      'dataHora': serializer.toJson<DateTime>(dataHora),
      'valorPagoCentavos': serializer.toJson<int>(valorPagoCentavos),
      'modalidade': serializer.toJson<String?>(modalidade),
      'validadeAte': serializer.toJson<DateTime?>(validadeAte),
      'limiteFaturamentoCentavos': serializer.toJson<int?>(
        limiteFaturamentoCentavos,
      ),
      'observacao': serializer.toJson<String?>(observacao),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
    };
  }

  PassesPlataformaData copyWith({
    int? id,
    int? plataformaId,
    Value<int?> jornadaId = const Value.absent(),
    DateTime? dataHora,
    int? valorPagoCentavos,
    Value<String?> modalidade = const Value.absent(),
    Value<DateTime?> validadeAte = const Value.absent(),
    Value<int?> limiteFaturamentoCentavos = const Value.absent(),
    Value<String?> observacao = const Value.absent(),
    DateTime? dataCriacao,
  }) => PassesPlataformaData(
    id: id ?? this.id,
    plataformaId: plataformaId ?? this.plataformaId,
    jornadaId: jornadaId.present ? jornadaId.value : this.jornadaId,
    dataHora: dataHora ?? this.dataHora,
    valorPagoCentavos: valorPagoCentavos ?? this.valorPagoCentavos,
    modalidade: modalidade.present ? modalidade.value : this.modalidade,
    validadeAte: validadeAte.present ? validadeAte.value : this.validadeAte,
    limiteFaturamentoCentavos: limiteFaturamentoCentavos.present
        ? limiteFaturamentoCentavos.value
        : this.limiteFaturamentoCentavos,
    observacao: observacao.present ? observacao.value : this.observacao,
    dataCriacao: dataCriacao ?? this.dataCriacao,
  );
  PassesPlataformaData copyWithCompanion(PassesPlataformaCompanion data) {
    return PassesPlataformaData(
      id: data.id.present ? data.id.value : this.id,
      plataformaId: data.plataformaId.present
          ? data.plataformaId.value
          : this.plataformaId,
      jornadaId: data.jornadaId.present ? data.jornadaId.value : this.jornadaId,
      dataHora: data.dataHora.present ? data.dataHora.value : this.dataHora,
      valorPagoCentavos: data.valorPagoCentavos.present
          ? data.valorPagoCentavos.value
          : this.valorPagoCentavos,
      modalidade: data.modalidade.present
          ? data.modalidade.value
          : this.modalidade,
      validadeAte: data.validadeAte.present
          ? data.validadeAte.value
          : this.validadeAte,
      limiteFaturamentoCentavos: data.limiteFaturamentoCentavos.present
          ? data.limiteFaturamentoCentavos.value
          : this.limiteFaturamentoCentavos,
      observacao: data.observacao.present
          ? data.observacao.value
          : this.observacao,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PassesPlataformaData(')
          ..write('id: $id, ')
          ..write('plataformaId: $plataformaId, ')
          ..write('jornadaId: $jornadaId, ')
          ..write('dataHora: $dataHora, ')
          ..write('valorPagoCentavos: $valorPagoCentavos, ')
          ..write('modalidade: $modalidade, ')
          ..write('validadeAte: $validadeAte, ')
          ..write('limiteFaturamentoCentavos: $limiteFaturamentoCentavos, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    plataformaId,
    jornadaId,
    dataHora,
    valorPagoCentavos,
    modalidade,
    validadeAte,
    limiteFaturamentoCentavos,
    observacao,
    dataCriacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PassesPlataformaData &&
          other.id == this.id &&
          other.plataformaId == this.plataformaId &&
          other.jornadaId == this.jornadaId &&
          other.dataHora == this.dataHora &&
          other.valorPagoCentavos == this.valorPagoCentavos &&
          other.modalidade == this.modalidade &&
          other.validadeAte == this.validadeAte &&
          other.limiteFaturamentoCentavos == this.limiteFaturamentoCentavos &&
          other.observacao == this.observacao &&
          other.dataCriacao == this.dataCriacao);
}

class PassesPlataformaCompanion extends UpdateCompanion<PassesPlataformaData> {
  final Value<int> id;
  final Value<int> plataformaId;
  final Value<int?> jornadaId;
  final Value<DateTime> dataHora;
  final Value<int> valorPagoCentavos;
  final Value<String?> modalidade;
  final Value<DateTime?> validadeAte;
  final Value<int?> limiteFaturamentoCentavos;
  final Value<String?> observacao;
  final Value<DateTime> dataCriacao;
  const PassesPlataformaCompanion({
    this.id = const Value.absent(),
    this.plataformaId = const Value.absent(),
    this.jornadaId = const Value.absent(),
    this.dataHora = const Value.absent(),
    this.valorPagoCentavos = const Value.absent(),
    this.modalidade = const Value.absent(),
    this.validadeAte = const Value.absent(),
    this.limiteFaturamentoCentavos = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  });
  PassesPlataformaCompanion.insert({
    this.id = const Value.absent(),
    required int plataformaId,
    this.jornadaId = const Value.absent(),
    required DateTime dataHora,
    required int valorPagoCentavos,
    this.modalidade = const Value.absent(),
    this.validadeAte = const Value.absent(),
    this.limiteFaturamentoCentavos = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  }) : plataformaId = Value(plataformaId),
       dataHora = Value(dataHora),
       valorPagoCentavos = Value(valorPagoCentavos);
  static Insertable<PassesPlataformaData> custom({
    Expression<int>? id,
    Expression<int>? plataformaId,
    Expression<int>? jornadaId,
    Expression<DateTime>? dataHora,
    Expression<int>? valorPagoCentavos,
    Expression<String>? modalidade,
    Expression<DateTime>? validadeAte,
    Expression<int>? limiteFaturamentoCentavos,
    Expression<String>? observacao,
    Expression<DateTime>? dataCriacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plataformaId != null) 'plataforma_id': plataformaId,
      if (jornadaId != null) 'jornada_id': jornadaId,
      if (dataHora != null) 'data_hora': dataHora,
      if (valorPagoCentavos != null) 'valor_pago_centavos': valorPagoCentavos,
      if (modalidade != null) 'modalidade': modalidade,
      if (validadeAte != null) 'validade_ate': validadeAte,
      if (limiteFaturamentoCentavos != null)
        'limite_faturamento_centavos': limiteFaturamentoCentavos,
      if (observacao != null) 'observacao': observacao,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
    });
  }

  PassesPlataformaCompanion copyWith({
    Value<int>? id,
    Value<int>? plataformaId,
    Value<int?>? jornadaId,
    Value<DateTime>? dataHora,
    Value<int>? valorPagoCentavos,
    Value<String?>? modalidade,
    Value<DateTime?>? validadeAte,
    Value<int?>? limiteFaturamentoCentavos,
    Value<String?>? observacao,
    Value<DateTime>? dataCriacao,
  }) {
    return PassesPlataformaCompanion(
      id: id ?? this.id,
      plataformaId: plataformaId ?? this.plataformaId,
      jornadaId: jornadaId ?? this.jornadaId,
      dataHora: dataHora ?? this.dataHora,
      valorPagoCentavos: valorPagoCentavos ?? this.valorPagoCentavos,
      modalidade: modalidade ?? this.modalidade,
      validadeAte: validadeAte ?? this.validadeAte,
      limiteFaturamentoCentavos:
          limiteFaturamentoCentavos ?? this.limiteFaturamentoCentavos,
      observacao: observacao ?? this.observacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plataformaId.present) {
      map['plataforma_id'] = Variable<int>(plataformaId.value);
    }
    if (jornadaId.present) {
      map['jornada_id'] = Variable<int>(jornadaId.value);
    }
    if (dataHora.present) {
      map['data_hora'] = Variable<DateTime>(dataHora.value);
    }
    if (valorPagoCentavos.present) {
      map['valor_pago_centavos'] = Variable<int>(valorPagoCentavos.value);
    }
    if (modalidade.present) {
      map['modalidade'] = Variable<String>(modalidade.value);
    }
    if (validadeAte.present) {
      map['validade_ate'] = Variable<DateTime>(validadeAte.value);
    }
    if (limiteFaturamentoCentavos.present) {
      map['limite_faturamento_centavos'] = Variable<int>(
        limiteFaturamentoCentavos.value,
      );
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PassesPlataformaCompanion(')
          ..write('id: $id, ')
          ..write('plataformaId: $plataformaId, ')
          ..write('jornadaId: $jornadaId, ')
          ..write('dataHora: $dataHora, ')
          ..write('valorPagoCentavos: $valorPagoCentavos, ')
          ..write('modalidade: $modalidade, ')
          ..write('validadeAte: $validadeAte, ')
          ..write('limiteFaturamentoCentavos: $limiteFaturamentoCentavos, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }
}

class $BonusPromocoesTable extends BonusPromocoes
    with TableInfo<$BonusPromocoesTable, BonusPromocao> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BonusPromocoesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _jornadaIdMeta = const VerificationMeta(
    'jornadaId',
  );
  @override
  late final GeneratedColumn<int> jornadaId = GeneratedColumn<int>(
    'jornada_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jornadas (id)',
    ),
  );
  static const VerificationMeta _dataHoraMeta = const VerificationMeta(
    'dataHora',
  );
  @override
  late final GeneratedColumn<DateTime> dataHora = GeneratedColumn<DateTime>(
    'data_hora',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorCentavosMeta = const VerificationMeta(
    'valorCentavos',
  );
  @override
  late final GeneratedColumn<int> valorCentavos = GeneratedColumn<int>(
    'valor_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoBonusPromocao, String> tipo =
      GeneratedColumn<String>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoBonusPromocao>($BonusPromocoesTable.$convertertipo);
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    plataformaId,
    jornadaId,
    dataHora,
    valorCentavos,
    tipo,
    observacao,
    dataCriacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bonus_promocoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<BonusPromocao> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('jornada_id')) {
      context.handle(
        _jornadaIdMeta,
        jornadaId.isAcceptableOrUnknown(data['jornada_id']!, _jornadaIdMeta),
      );
    }
    if (data.containsKey('data_hora')) {
      context.handle(
        _dataHoraMeta,
        dataHora.isAcceptableOrUnknown(data['data_hora']!, _dataHoraMeta),
      );
    } else if (isInserting) {
      context.missing(_dataHoraMeta);
    }
    if (data.containsKey('valor_centavos')) {
      context.handle(
        _valorCentavosMeta,
        valorCentavos.isAcceptableOrUnknown(
          data['valor_centavos']!,
          _valorCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorCentavosMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BonusPromocao map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BonusPromocao(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      plataformaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plataforma_id'],
      )!,
      jornadaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jornada_id'],
      ),
      dataHora: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora'],
      )!,
      valorCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_centavos'],
      )!,
      tipo: $BonusPromocoesTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      observacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacao'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
    );
  }

  @override
  $BonusPromocoesTable createAlias(String alias) {
    return $BonusPromocoesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoBonusPromocao, String, String> $convertertipo =
      const EnumNameConverter<TipoBonusPromocao>(TipoBonusPromocao.values);
}

class BonusPromocao extends DataClass implements Insertable<BonusPromocao> {
  final int id;
  final int plataformaId;
  final int? jornadaId;
  final DateTime dataHora;
  final int valorCentavos;
  final TipoBonusPromocao tipo;
  final String? observacao;
  final DateTime dataCriacao;
  const BonusPromocao({
    required this.id,
    required this.plataformaId,
    this.jornadaId,
    required this.dataHora,
    required this.valorCentavos,
    required this.tipo,
    this.observacao,
    required this.dataCriacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plataforma_id'] = Variable<int>(plataformaId);
    if (!nullToAbsent || jornadaId != null) {
      map['jornada_id'] = Variable<int>(jornadaId);
    }
    map['data_hora'] = Variable<DateTime>(dataHora);
    map['valor_centavos'] = Variable<int>(valorCentavos);
    {
      map['tipo'] = Variable<String>(
        $BonusPromocoesTable.$convertertipo.toSql(tipo),
      );
    }
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    return map;
  }

  BonusPromocoesCompanion toCompanion(bool nullToAbsent) {
    return BonusPromocoesCompanion(
      id: Value(id),
      plataformaId: Value(plataformaId),
      jornadaId: jornadaId == null && nullToAbsent
          ? const Value.absent()
          : Value(jornadaId),
      dataHora: Value(dataHora),
      valorCentavos: Value(valorCentavos),
      tipo: Value(tipo),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
      dataCriacao: Value(dataCriacao),
    );
  }

  factory BonusPromocao.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BonusPromocao(
      id: serializer.fromJson<int>(json['id']),
      plataformaId: serializer.fromJson<int>(json['plataformaId']),
      jornadaId: serializer.fromJson<int?>(json['jornadaId']),
      dataHora: serializer.fromJson<DateTime>(json['dataHora']),
      valorCentavos: serializer.fromJson<int>(json['valorCentavos']),
      tipo: $BonusPromocoesTable.$convertertipo.fromJson(
        serializer.fromJson<String>(json['tipo']),
      ),
      observacao: serializer.fromJson<String?>(json['observacao']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plataformaId': serializer.toJson<int>(plataformaId),
      'jornadaId': serializer.toJson<int?>(jornadaId),
      'dataHora': serializer.toJson<DateTime>(dataHora),
      'valorCentavos': serializer.toJson<int>(valorCentavos),
      'tipo': serializer.toJson<String>(
        $BonusPromocoesTable.$convertertipo.toJson(tipo),
      ),
      'observacao': serializer.toJson<String?>(observacao),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
    };
  }

  BonusPromocao copyWith({
    int? id,
    int? plataformaId,
    Value<int?> jornadaId = const Value.absent(),
    DateTime? dataHora,
    int? valorCentavos,
    TipoBonusPromocao? tipo,
    Value<String?> observacao = const Value.absent(),
    DateTime? dataCriacao,
  }) => BonusPromocao(
    id: id ?? this.id,
    plataformaId: plataformaId ?? this.plataformaId,
    jornadaId: jornadaId.present ? jornadaId.value : this.jornadaId,
    dataHora: dataHora ?? this.dataHora,
    valorCentavos: valorCentavos ?? this.valorCentavos,
    tipo: tipo ?? this.tipo,
    observacao: observacao.present ? observacao.value : this.observacao,
    dataCriacao: dataCriacao ?? this.dataCriacao,
  );
  BonusPromocao copyWithCompanion(BonusPromocoesCompanion data) {
    return BonusPromocao(
      id: data.id.present ? data.id.value : this.id,
      plataformaId: data.plataformaId.present
          ? data.plataformaId.value
          : this.plataformaId,
      jornadaId: data.jornadaId.present ? data.jornadaId.value : this.jornadaId,
      dataHora: data.dataHora.present ? data.dataHora.value : this.dataHora,
      valorCentavos: data.valorCentavos.present
          ? data.valorCentavos.value
          : this.valorCentavos,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      observacao: data.observacao.present
          ? data.observacao.value
          : this.observacao,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BonusPromocao(')
          ..write('id: $id, ')
          ..write('plataformaId: $plataformaId, ')
          ..write('jornadaId: $jornadaId, ')
          ..write('dataHora: $dataHora, ')
          ..write('valorCentavos: $valorCentavos, ')
          ..write('tipo: $tipo, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    plataformaId,
    jornadaId,
    dataHora,
    valorCentavos,
    tipo,
    observacao,
    dataCriacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BonusPromocao &&
          other.id == this.id &&
          other.plataformaId == this.plataformaId &&
          other.jornadaId == this.jornadaId &&
          other.dataHora == this.dataHora &&
          other.valorCentavos == this.valorCentavos &&
          other.tipo == this.tipo &&
          other.observacao == this.observacao &&
          other.dataCriacao == this.dataCriacao);
}

class BonusPromocoesCompanion extends UpdateCompanion<BonusPromocao> {
  final Value<int> id;
  final Value<int> plataformaId;
  final Value<int?> jornadaId;
  final Value<DateTime> dataHora;
  final Value<int> valorCentavos;
  final Value<TipoBonusPromocao> tipo;
  final Value<String?> observacao;
  final Value<DateTime> dataCriacao;
  const BonusPromocoesCompanion({
    this.id = const Value.absent(),
    this.plataformaId = const Value.absent(),
    this.jornadaId = const Value.absent(),
    this.dataHora = const Value.absent(),
    this.valorCentavos = const Value.absent(),
    this.tipo = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  });
  BonusPromocoesCompanion.insert({
    this.id = const Value.absent(),
    required int plataformaId,
    this.jornadaId = const Value.absent(),
    required DateTime dataHora,
    required int valorCentavos,
    required TipoBonusPromocao tipo,
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  }) : plataformaId = Value(plataformaId),
       dataHora = Value(dataHora),
       valorCentavos = Value(valorCentavos),
       tipo = Value(tipo);
  static Insertable<BonusPromocao> custom({
    Expression<int>? id,
    Expression<int>? plataformaId,
    Expression<int>? jornadaId,
    Expression<DateTime>? dataHora,
    Expression<int>? valorCentavos,
    Expression<String>? tipo,
    Expression<String>? observacao,
    Expression<DateTime>? dataCriacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plataformaId != null) 'plataforma_id': plataformaId,
      if (jornadaId != null) 'jornada_id': jornadaId,
      if (dataHora != null) 'data_hora': dataHora,
      if (valorCentavos != null) 'valor_centavos': valorCentavos,
      if (tipo != null) 'tipo': tipo,
      if (observacao != null) 'observacao': observacao,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
    });
  }

  BonusPromocoesCompanion copyWith({
    Value<int>? id,
    Value<int>? plataformaId,
    Value<int?>? jornadaId,
    Value<DateTime>? dataHora,
    Value<int>? valorCentavos,
    Value<TipoBonusPromocao>? tipo,
    Value<String?>? observacao,
    Value<DateTime>? dataCriacao,
  }) {
    return BonusPromocoesCompanion(
      id: id ?? this.id,
      plataformaId: plataformaId ?? this.plataformaId,
      jornadaId: jornadaId ?? this.jornadaId,
      dataHora: dataHora ?? this.dataHora,
      valorCentavos: valorCentavos ?? this.valorCentavos,
      tipo: tipo ?? this.tipo,
      observacao: observacao ?? this.observacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plataformaId.present) {
      map['plataforma_id'] = Variable<int>(plataformaId.value);
    }
    if (jornadaId.present) {
      map['jornada_id'] = Variable<int>(jornadaId.value);
    }
    if (dataHora.present) {
      map['data_hora'] = Variable<DateTime>(dataHora.value);
    }
    if (valorCentavos.present) {
      map['valor_centavos'] = Variable<int>(valorCentavos.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
        $BonusPromocoesTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BonusPromocoesCompanion(')
          ..write('id: $id, ')
          ..write('plataformaId: $plataformaId, ')
          ..write('jornadaId: $jornadaId, ')
          ..write('dataHora: $dataHora, ')
          ..write('valorCentavos: $valorCentavos, ')
          ..write('tipo: $tipo, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }
}

class $ManutencoesTable extends Manutencoes
    with TableInfo<$ManutencoesTable, Manutencao> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ManutencoesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dataHoraMeta = const VerificationMeta(
    'dataHora',
  );
  @override
  late final GeneratedColumn<DateTime> dataHora = GeneratedColumn<DateTime>(
    'data_hora',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometroMeta = const VerificationMeta(
    'odometro',
  );
  @override
  late final GeneratedColumn<int> odometro = GeneratedColumn<int>(
    'odometro',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _oficinaMeta = const VerificationMeta(
    'oficina',
  );
  @override
  late final GeneratedColumn<String> oficina = GeneratedColumn<String>(
    'oficina',
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
  static const VerificationMeta _dataAtualizacaoMeta = const VerificationMeta(
    'dataAtualizacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataAtualizacao =
      GeneratedColumn<DateTime>(
        'data_atualizacao',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    veiculoId,
    dataHora,
    odometro,
    oficina,
    observacao,
    dataCriacao,
    dataAtualizacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manutencoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Manutencao> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('veiculo_id')) {
      context.handle(
        _veiculoIdMeta,
        veiculoId.isAcceptableOrUnknown(data['veiculo_id']!, _veiculoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_veiculoIdMeta);
    }
    if (data.containsKey('data_hora')) {
      context.handle(
        _dataHoraMeta,
        dataHora.isAcceptableOrUnknown(data['data_hora']!, _dataHoraMeta),
      );
    } else if (isInserting) {
      context.missing(_dataHoraMeta);
    }
    if (data.containsKey('odometro')) {
      context.handle(
        _odometroMeta,
        odometro.isAcceptableOrUnknown(data['odometro']!, _odometroMeta),
      );
    } else if (isInserting) {
      context.missing(_odometroMeta);
    }
    if (data.containsKey('oficina')) {
      context.handle(
        _oficinaMeta,
        oficina.isAcceptableOrUnknown(data['oficina']!, _oficinaMeta),
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
    if (data.containsKey('data_atualizacao')) {
      context.handle(
        _dataAtualizacaoMeta,
        dataAtualizacao.isAcceptableOrUnknown(
          data['data_atualizacao']!,
          _dataAtualizacaoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Manutencao map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Manutencao(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      veiculoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}veiculo_id'],
      )!,
      dataHora: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora'],
      )!,
      odometro: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odometro'],
      )!,
      oficina: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oficina'],
      ),
      observacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacao'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      dataAtualizacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_atualizacao'],
      ),
    );
  }

  @override
  $ManutencoesTable createAlias(String alias) {
    return $ManutencoesTable(attachedDatabase, alias);
  }
}

class Manutencao extends DataClass implements Insertable<Manutencao> {
  final int id;
  final int veiculoId;
  final DateTime dataHora;
  final int odometro;
  final String? oficina;
  final String? observacao;
  final DateTime dataCriacao;
  final DateTime? dataAtualizacao;
  const Manutencao({
    required this.id,
    required this.veiculoId,
    required this.dataHora,
    required this.odometro,
    this.oficina,
    this.observacao,
    required this.dataCriacao,
    this.dataAtualizacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['veiculo_id'] = Variable<int>(veiculoId);
    map['data_hora'] = Variable<DateTime>(dataHora);
    map['odometro'] = Variable<int>(odometro);
    if (!nullToAbsent || oficina != null) {
      map['oficina'] = Variable<String>(oficina);
    }
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    if (!nullToAbsent || dataAtualizacao != null) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao);
    }
    return map;
  }

  ManutencoesCompanion toCompanion(bool nullToAbsent) {
    return ManutencoesCompanion(
      id: Value(id),
      veiculoId: Value(veiculoId),
      dataHora: Value(dataHora),
      odometro: Value(odometro),
      oficina: oficina == null && nullToAbsent
          ? const Value.absent()
          : Value(oficina),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
      dataCriacao: Value(dataCriacao),
      dataAtualizacao: dataAtualizacao == null && nullToAbsent
          ? const Value.absent()
          : Value(dataAtualizacao),
    );
  }

  factory Manutencao.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Manutencao(
      id: serializer.fromJson<int>(json['id']),
      veiculoId: serializer.fromJson<int>(json['veiculoId']),
      dataHora: serializer.fromJson<DateTime>(json['dataHora']),
      odometro: serializer.fromJson<int>(json['odometro']),
      oficina: serializer.fromJson<String?>(json['oficina']),
      observacao: serializer.fromJson<String?>(json['observacao']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      dataAtualizacao: serializer.fromJson<DateTime?>(json['dataAtualizacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'veiculoId': serializer.toJson<int>(veiculoId),
      'dataHora': serializer.toJson<DateTime>(dataHora),
      'odometro': serializer.toJson<int>(odometro),
      'oficina': serializer.toJson<String?>(oficina),
      'observacao': serializer.toJson<String?>(observacao),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'dataAtualizacao': serializer.toJson<DateTime?>(dataAtualizacao),
    };
  }

  Manutencao copyWith({
    int? id,
    int? veiculoId,
    DateTime? dataHora,
    int? odometro,
    Value<String?> oficina = const Value.absent(),
    Value<String?> observacao = const Value.absent(),
    DateTime? dataCriacao,
    Value<DateTime?> dataAtualizacao = const Value.absent(),
  }) => Manutencao(
    id: id ?? this.id,
    veiculoId: veiculoId ?? this.veiculoId,
    dataHora: dataHora ?? this.dataHora,
    odometro: odometro ?? this.odometro,
    oficina: oficina.present ? oficina.value : this.oficina,
    observacao: observacao.present ? observacao.value : this.observacao,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    dataAtualizacao: dataAtualizacao.present
        ? dataAtualizacao.value
        : this.dataAtualizacao,
  );
  Manutencao copyWithCompanion(ManutencoesCompanion data) {
    return Manutencao(
      id: data.id.present ? data.id.value : this.id,
      veiculoId: data.veiculoId.present ? data.veiculoId.value : this.veiculoId,
      dataHora: data.dataHora.present ? data.dataHora.value : this.dataHora,
      odometro: data.odometro.present ? data.odometro.value : this.odometro,
      oficina: data.oficina.present ? data.oficina.value : this.oficina,
      observacao: data.observacao.present
          ? data.observacao.value
          : this.observacao,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      dataAtualizacao: data.dataAtualizacao.present
          ? data.dataAtualizacao.value
          : this.dataAtualizacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Manutencao(')
          ..write('id: $id, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('dataHora: $dataHora, ')
          ..write('odometro: $odometro, ')
          ..write('oficina: $oficina, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    veiculoId,
    dataHora,
    odometro,
    oficina,
    observacao,
    dataCriacao,
    dataAtualizacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Manutencao &&
          other.id == this.id &&
          other.veiculoId == this.veiculoId &&
          other.dataHora == this.dataHora &&
          other.odometro == this.odometro &&
          other.oficina == this.oficina &&
          other.observacao == this.observacao &&
          other.dataCriacao == this.dataCriacao &&
          other.dataAtualizacao == this.dataAtualizacao);
}

class ManutencoesCompanion extends UpdateCompanion<Manutencao> {
  final Value<int> id;
  final Value<int> veiculoId;
  final Value<DateTime> dataHora;
  final Value<int> odometro;
  final Value<String?> oficina;
  final Value<String?> observacao;
  final Value<DateTime> dataCriacao;
  final Value<DateTime?> dataAtualizacao;
  const ManutencoesCompanion({
    this.id = const Value.absent(),
    this.veiculoId = const Value.absent(),
    this.dataHora = const Value.absent(),
    this.odometro = const Value.absent(),
    this.oficina = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  });
  ManutencoesCompanion.insert({
    this.id = const Value.absent(),
    required int veiculoId,
    required DateTime dataHora,
    required int odometro,
    this.oficina = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  }) : veiculoId = Value(veiculoId),
       dataHora = Value(dataHora),
       odometro = Value(odometro);
  static Insertable<Manutencao> custom({
    Expression<int>? id,
    Expression<int>? veiculoId,
    Expression<DateTime>? dataHora,
    Expression<int>? odometro,
    Expression<String>? oficina,
    Expression<String>? observacao,
    Expression<DateTime>? dataCriacao,
    Expression<DateTime>? dataAtualizacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (veiculoId != null) 'veiculo_id': veiculoId,
      if (dataHora != null) 'data_hora': dataHora,
      if (odometro != null) 'odometro': odometro,
      if (oficina != null) 'oficina': oficina,
      if (observacao != null) 'observacao': observacao,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (dataAtualizacao != null) 'data_atualizacao': dataAtualizacao,
    });
  }

  ManutencoesCompanion copyWith({
    Value<int>? id,
    Value<int>? veiculoId,
    Value<DateTime>? dataHora,
    Value<int>? odometro,
    Value<String?>? oficina,
    Value<String?>? observacao,
    Value<DateTime>? dataCriacao,
    Value<DateTime?>? dataAtualizacao,
  }) {
    return ManutencoesCompanion(
      id: id ?? this.id,
      veiculoId: veiculoId ?? this.veiculoId,
      dataHora: dataHora ?? this.dataHora,
      odometro: odometro ?? this.odometro,
      oficina: oficina ?? this.oficina,
      observacao: observacao ?? this.observacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (veiculoId.present) {
      map['veiculo_id'] = Variable<int>(veiculoId.value);
    }
    if (dataHora.present) {
      map['data_hora'] = Variable<DateTime>(dataHora.value);
    }
    if (odometro.present) {
      map['odometro'] = Variable<int>(odometro.value);
    }
    if (oficina.present) {
      map['oficina'] = Variable<String>(oficina.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (dataAtualizacao.present) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ManutencoesCompanion(')
          ..write('id: $id, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('dataHora: $dataHora, ')
          ..write('odometro: $odometro, ')
          ..write('oficina: $oficina, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }
}

class $ItensManutencaoTable extends ItensManutencao
    with TableInfo<$ItensManutencaoTable, ItemManutencao> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItensManutencaoTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _manutencaoIdMeta = const VerificationMeta(
    'manutencaoId',
  );
  @override
  late final GeneratedColumn<int> manutencaoId = GeneratedColumn<int>(
    'manutencao_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES manutencoes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorCentavosMeta = const VerificationMeta(
    'valorCentavos',
  );
  @override
  late final GeneratedColumn<int> valorCentavos = GeneratedColumn<int>(
    'valor_centavos',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intervaloKmMeta = const VerificationMeta(
    'intervaloKm',
  );
  @override
  late final GeneratedColumn<int> intervaloKm = GeneratedColumn<int>(
    'intervalo_km',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vencimentoEmMeta = const VerificationMeta(
    'vencimentoEm',
  );
  @override
  late final GeneratedColumn<DateTime> vencimentoEm = GeneratedColumn<DateTime>(
    'vencimento_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    manutencaoId,
    descricao,
    valorCentavos,
    intervaloKm,
    vencimentoEm,
    dataCriacao,
    dataAtualizacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'itens_manutencao';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemManutencao> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('manutencao_id')) {
      context.handle(
        _manutencaoIdMeta,
        manutencaoId.isAcceptableOrUnknown(
          data['manutencao_id']!,
          _manutencaoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_manutencaoIdMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('valor_centavos')) {
      context.handle(
        _valorCentavosMeta,
        valorCentavos.isAcceptableOrUnknown(
          data['valor_centavos']!,
          _valorCentavosMeta,
        ),
      );
    }
    if (data.containsKey('intervalo_km')) {
      context.handle(
        _intervaloKmMeta,
        intervaloKm.isAcceptableOrUnknown(
          data['intervalo_km']!,
          _intervaloKmMeta,
        ),
      );
    }
    if (data.containsKey('vencimento_em')) {
      context.handle(
        _vencimentoEmMeta,
        vencimentoEm.isAcceptableOrUnknown(
          data['vencimento_em']!,
          _vencimentoEmMeta,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemManutencao map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemManutencao(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      manutencaoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}manutencao_id'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      )!,
      valorCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_centavos'],
      ),
      intervaloKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intervalo_km'],
      ),
      vencimentoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}vencimento_em'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      dataAtualizacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_atualizacao'],
      ),
    );
  }

  @override
  $ItensManutencaoTable createAlias(String alias) {
    return $ItensManutencaoTable(attachedDatabase, alias);
  }
}

class ItemManutencao extends DataClass implements Insertable<ItemManutencao> {
  final int id;
  final int manutencaoId;
  final String descricao;
  final int? valorCentavos;
  final int? intervaloKm;
  final DateTime? vencimentoEm;
  final DateTime dataCriacao;
  final DateTime? dataAtualizacao;
  const ItemManutencao({
    required this.id,
    required this.manutencaoId,
    required this.descricao,
    this.valorCentavos,
    this.intervaloKm,
    this.vencimentoEm,
    required this.dataCriacao,
    this.dataAtualizacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['manutencao_id'] = Variable<int>(manutencaoId);
    map['descricao'] = Variable<String>(descricao);
    if (!nullToAbsent || valorCentavos != null) {
      map['valor_centavos'] = Variable<int>(valorCentavos);
    }
    if (!nullToAbsent || intervaloKm != null) {
      map['intervalo_km'] = Variable<int>(intervaloKm);
    }
    if (!nullToAbsent || vencimentoEm != null) {
      map['vencimento_em'] = Variable<DateTime>(vencimentoEm);
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    if (!nullToAbsent || dataAtualizacao != null) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao);
    }
    return map;
  }

  ItensManutencaoCompanion toCompanion(bool nullToAbsent) {
    return ItensManutencaoCompanion(
      id: Value(id),
      manutencaoId: Value(manutencaoId),
      descricao: Value(descricao),
      valorCentavos: valorCentavos == null && nullToAbsent
          ? const Value.absent()
          : Value(valorCentavos),
      intervaloKm: intervaloKm == null && nullToAbsent
          ? const Value.absent()
          : Value(intervaloKm),
      vencimentoEm: vencimentoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(vencimentoEm),
      dataCriacao: Value(dataCriacao),
      dataAtualizacao: dataAtualizacao == null && nullToAbsent
          ? const Value.absent()
          : Value(dataAtualizacao),
    );
  }

  factory ItemManutencao.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemManutencao(
      id: serializer.fromJson<int>(json['id']),
      manutencaoId: serializer.fromJson<int>(json['manutencaoId']),
      descricao: serializer.fromJson<String>(json['descricao']),
      valorCentavos: serializer.fromJson<int?>(json['valorCentavos']),
      intervaloKm: serializer.fromJson<int?>(json['intervaloKm']),
      vencimentoEm: serializer.fromJson<DateTime?>(json['vencimentoEm']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      dataAtualizacao: serializer.fromJson<DateTime?>(json['dataAtualizacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'manutencaoId': serializer.toJson<int>(manutencaoId),
      'descricao': serializer.toJson<String>(descricao),
      'valorCentavos': serializer.toJson<int?>(valorCentavos),
      'intervaloKm': serializer.toJson<int?>(intervaloKm),
      'vencimentoEm': serializer.toJson<DateTime?>(vencimentoEm),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'dataAtualizacao': serializer.toJson<DateTime?>(dataAtualizacao),
    };
  }

  ItemManutencao copyWith({
    int? id,
    int? manutencaoId,
    String? descricao,
    Value<int?> valorCentavos = const Value.absent(),
    Value<int?> intervaloKm = const Value.absent(),
    Value<DateTime?> vencimentoEm = const Value.absent(),
    DateTime? dataCriacao,
    Value<DateTime?> dataAtualizacao = const Value.absent(),
  }) => ItemManutencao(
    id: id ?? this.id,
    manutencaoId: manutencaoId ?? this.manutencaoId,
    descricao: descricao ?? this.descricao,
    valorCentavos: valorCentavos.present
        ? valorCentavos.value
        : this.valorCentavos,
    intervaloKm: intervaloKm.present ? intervaloKm.value : this.intervaloKm,
    vencimentoEm: vencimentoEm.present ? vencimentoEm.value : this.vencimentoEm,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    dataAtualizacao: dataAtualizacao.present
        ? dataAtualizacao.value
        : this.dataAtualizacao,
  );
  ItemManutencao copyWithCompanion(ItensManutencaoCompanion data) {
    return ItemManutencao(
      id: data.id.present ? data.id.value : this.id,
      manutencaoId: data.manutencaoId.present
          ? data.manutencaoId.value
          : this.manutencaoId,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      valorCentavos: data.valorCentavos.present
          ? data.valorCentavos.value
          : this.valorCentavos,
      intervaloKm: data.intervaloKm.present
          ? data.intervaloKm.value
          : this.intervaloKm,
      vencimentoEm: data.vencimentoEm.present
          ? data.vencimentoEm.value
          : this.vencimentoEm,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      dataAtualizacao: data.dataAtualizacao.present
          ? data.dataAtualizacao.value
          : this.dataAtualizacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemManutencao(')
          ..write('id: $id, ')
          ..write('manutencaoId: $manutencaoId, ')
          ..write('descricao: $descricao, ')
          ..write('valorCentavos: $valorCentavos, ')
          ..write('intervaloKm: $intervaloKm, ')
          ..write('vencimentoEm: $vencimentoEm, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    manutencaoId,
    descricao,
    valorCentavos,
    intervaloKm,
    vencimentoEm,
    dataCriacao,
    dataAtualizacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemManutencao &&
          other.id == this.id &&
          other.manutencaoId == this.manutencaoId &&
          other.descricao == this.descricao &&
          other.valorCentavos == this.valorCentavos &&
          other.intervaloKm == this.intervaloKm &&
          other.vencimentoEm == this.vencimentoEm &&
          other.dataCriacao == this.dataCriacao &&
          other.dataAtualizacao == this.dataAtualizacao);
}

class ItensManutencaoCompanion extends UpdateCompanion<ItemManutencao> {
  final Value<int> id;
  final Value<int> manutencaoId;
  final Value<String> descricao;
  final Value<int?> valorCentavos;
  final Value<int?> intervaloKm;
  final Value<DateTime?> vencimentoEm;
  final Value<DateTime> dataCriacao;
  final Value<DateTime?> dataAtualizacao;
  const ItensManutencaoCompanion({
    this.id = const Value.absent(),
    this.manutencaoId = const Value.absent(),
    this.descricao = const Value.absent(),
    this.valorCentavos = const Value.absent(),
    this.intervaloKm = const Value.absent(),
    this.vencimentoEm = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  });
  ItensManutencaoCompanion.insert({
    this.id = const Value.absent(),
    required int manutencaoId,
    required String descricao,
    this.valorCentavos = const Value.absent(),
    this.intervaloKm = const Value.absent(),
    this.vencimentoEm = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  }) : manutencaoId = Value(manutencaoId),
       descricao = Value(descricao);
  static Insertable<ItemManutencao> custom({
    Expression<int>? id,
    Expression<int>? manutencaoId,
    Expression<String>? descricao,
    Expression<int>? valorCentavos,
    Expression<int>? intervaloKm,
    Expression<DateTime>? vencimentoEm,
    Expression<DateTime>? dataCriacao,
    Expression<DateTime>? dataAtualizacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (manutencaoId != null) 'manutencao_id': manutencaoId,
      if (descricao != null) 'descricao': descricao,
      if (valorCentavos != null) 'valor_centavos': valorCentavos,
      if (intervaloKm != null) 'intervalo_km': intervaloKm,
      if (vencimentoEm != null) 'vencimento_em': vencimentoEm,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (dataAtualizacao != null) 'data_atualizacao': dataAtualizacao,
    });
  }

  ItensManutencaoCompanion copyWith({
    Value<int>? id,
    Value<int>? manutencaoId,
    Value<String>? descricao,
    Value<int?>? valorCentavos,
    Value<int?>? intervaloKm,
    Value<DateTime?>? vencimentoEm,
    Value<DateTime>? dataCriacao,
    Value<DateTime?>? dataAtualizacao,
  }) {
    return ItensManutencaoCompanion(
      id: id ?? this.id,
      manutencaoId: manutencaoId ?? this.manutencaoId,
      descricao: descricao ?? this.descricao,
      valorCentavos: valorCentavos ?? this.valorCentavos,
      intervaloKm: intervaloKm ?? this.intervaloKm,
      vencimentoEm: vencimentoEm ?? this.vencimentoEm,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (manutencaoId.present) {
      map['manutencao_id'] = Variable<int>(manutencaoId.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (valorCentavos.present) {
      map['valor_centavos'] = Variable<int>(valorCentavos.value);
    }
    if (intervaloKm.present) {
      map['intervalo_km'] = Variable<int>(intervaloKm.value);
    }
    if (vencimentoEm.present) {
      map['vencimento_em'] = Variable<DateTime>(vencimentoEm.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (dataAtualizacao.present) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItensManutencaoCompanion(')
          ..write('id: $id, ')
          ..write('manutencaoId: $manutencaoId, ')
          ..write('descricao: $descricao, ')
          ..write('valorCentavos: $valorCentavos, ')
          ..write('intervaloKm: $intervaloKm, ')
          ..write('vencimentoEm: $vencimentoEm, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }
}

class $DespesasVeiculoTable extends DespesasVeiculo
    with TableInfo<$DespesasVeiculoTable, DespesaVeiculo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DespesasVeiculoTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<TipoDespesaVeiculo, String> tipo =
      GeneratedColumn<String>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoDespesaVeiculo>($DespesasVeiculoTable.$convertertipo);
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorCentavosMeta = const VerificationMeta(
    'valorCentavos',
  );
  @override
  late final GeneratedColumn<int> valorCentavos = GeneratedColumn<int>(
    'valor_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataHoraMeta = const VerificationMeta(
    'dataHora',
  );
  @override
  late final GeneratedColumn<DateTime> dataHora = GeneratedColumn<DateTime>(
    'data_hora',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
  static const VerificationMeta _dataAtualizacaoMeta = const VerificationMeta(
    'dataAtualizacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataAtualizacao =
      GeneratedColumn<DateTime>(
        'data_atualizacao',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    veiculoId,
    tipo,
    descricao,
    valorCentavos,
    dataHora,
    observacao,
    dataCriacao,
    dataAtualizacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'despesas_veiculo';
  @override
  VerificationContext validateIntegrity(
    Insertable<DespesaVeiculo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('veiculo_id')) {
      context.handle(
        _veiculoIdMeta,
        veiculoId.isAcceptableOrUnknown(data['veiculo_id']!, _veiculoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_veiculoIdMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('valor_centavos')) {
      context.handle(
        _valorCentavosMeta,
        valorCentavos.isAcceptableOrUnknown(
          data['valor_centavos']!,
          _valorCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valorCentavosMeta);
    }
    if (data.containsKey('data_hora')) {
      context.handle(
        _dataHoraMeta,
        dataHora.isAcceptableOrUnknown(data['data_hora']!, _dataHoraMeta),
      );
    } else if (isInserting) {
      context.missing(_dataHoraMeta);
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
    if (data.containsKey('data_atualizacao')) {
      context.handle(
        _dataAtualizacaoMeta,
        dataAtualizacao.isAcceptableOrUnknown(
          data['data_atualizacao']!,
          _dataAtualizacaoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DespesaVeiculo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DespesaVeiculo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      veiculoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}veiculo_id'],
      )!,
      tipo: $DespesasVeiculoTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      )!,
      valorCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_centavos'],
      )!,
      dataHora: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora'],
      )!,
      observacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacao'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      dataAtualizacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_atualizacao'],
      ),
    );
  }

  @override
  $DespesasVeiculoTable createAlias(String alias) {
    return $DespesasVeiculoTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoDespesaVeiculo, String, String> $convertertipo =
      const EnumNameConverter<TipoDespesaVeiculo>(TipoDespesaVeiculo.values);
}

class DespesaVeiculo extends DataClass implements Insertable<DespesaVeiculo> {
  final int id;
  final int veiculoId;
  final TipoDespesaVeiculo tipo;
  final String descricao;
  final int valorCentavos;
  final DateTime dataHora;
  final String? observacao;
  final DateTime dataCriacao;
  final DateTime? dataAtualizacao;
  const DespesaVeiculo({
    required this.id,
    required this.veiculoId,
    required this.tipo,
    required this.descricao,
    required this.valorCentavos,
    required this.dataHora,
    this.observacao,
    required this.dataCriacao,
    this.dataAtualizacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['veiculo_id'] = Variable<int>(veiculoId);
    {
      map['tipo'] = Variable<String>(
        $DespesasVeiculoTable.$convertertipo.toSql(tipo),
      );
    }
    map['descricao'] = Variable<String>(descricao);
    map['valor_centavos'] = Variable<int>(valorCentavos);
    map['data_hora'] = Variable<DateTime>(dataHora);
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    if (!nullToAbsent || dataAtualizacao != null) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao);
    }
    return map;
  }

  DespesasVeiculoCompanion toCompanion(bool nullToAbsent) {
    return DespesasVeiculoCompanion(
      id: Value(id),
      veiculoId: Value(veiculoId),
      tipo: Value(tipo),
      descricao: Value(descricao),
      valorCentavos: Value(valorCentavos),
      dataHora: Value(dataHora),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
      dataCriacao: Value(dataCriacao),
      dataAtualizacao: dataAtualizacao == null && nullToAbsent
          ? const Value.absent()
          : Value(dataAtualizacao),
    );
  }

  factory DespesaVeiculo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DespesaVeiculo(
      id: serializer.fromJson<int>(json['id']),
      veiculoId: serializer.fromJson<int>(json['veiculoId']),
      tipo: $DespesasVeiculoTable.$convertertipo.fromJson(
        serializer.fromJson<String>(json['tipo']),
      ),
      descricao: serializer.fromJson<String>(json['descricao']),
      valorCentavos: serializer.fromJson<int>(json['valorCentavos']),
      dataHora: serializer.fromJson<DateTime>(json['dataHora']),
      observacao: serializer.fromJson<String?>(json['observacao']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      dataAtualizacao: serializer.fromJson<DateTime?>(json['dataAtualizacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'veiculoId': serializer.toJson<int>(veiculoId),
      'tipo': serializer.toJson<String>(
        $DespesasVeiculoTable.$convertertipo.toJson(tipo),
      ),
      'descricao': serializer.toJson<String>(descricao),
      'valorCentavos': serializer.toJson<int>(valorCentavos),
      'dataHora': serializer.toJson<DateTime>(dataHora),
      'observacao': serializer.toJson<String?>(observacao),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'dataAtualizacao': serializer.toJson<DateTime?>(dataAtualizacao),
    };
  }

  DespesaVeiculo copyWith({
    int? id,
    int? veiculoId,
    TipoDespesaVeiculo? tipo,
    String? descricao,
    int? valorCentavos,
    DateTime? dataHora,
    Value<String?> observacao = const Value.absent(),
    DateTime? dataCriacao,
    Value<DateTime?> dataAtualizacao = const Value.absent(),
  }) => DespesaVeiculo(
    id: id ?? this.id,
    veiculoId: veiculoId ?? this.veiculoId,
    tipo: tipo ?? this.tipo,
    descricao: descricao ?? this.descricao,
    valorCentavos: valorCentavos ?? this.valorCentavos,
    dataHora: dataHora ?? this.dataHora,
    observacao: observacao.present ? observacao.value : this.observacao,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    dataAtualizacao: dataAtualizacao.present
        ? dataAtualizacao.value
        : this.dataAtualizacao,
  );
  DespesaVeiculo copyWithCompanion(DespesasVeiculoCompanion data) {
    return DespesaVeiculo(
      id: data.id.present ? data.id.value : this.id,
      veiculoId: data.veiculoId.present ? data.veiculoId.value : this.veiculoId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      valorCentavos: data.valorCentavos.present
          ? data.valorCentavos.value
          : this.valorCentavos,
      dataHora: data.dataHora.present ? data.dataHora.value : this.dataHora,
      observacao: data.observacao.present
          ? data.observacao.value
          : this.observacao,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      dataAtualizacao: data.dataAtualizacao.present
          ? data.dataAtualizacao.value
          : this.dataAtualizacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DespesaVeiculo(')
          ..write('id: $id, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('tipo: $tipo, ')
          ..write('descricao: $descricao, ')
          ..write('valorCentavos: $valorCentavos, ')
          ..write('dataHora: $dataHora, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    veiculoId,
    tipo,
    descricao,
    valorCentavos,
    dataHora,
    observacao,
    dataCriacao,
    dataAtualizacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DespesaVeiculo &&
          other.id == this.id &&
          other.veiculoId == this.veiculoId &&
          other.tipo == this.tipo &&
          other.descricao == this.descricao &&
          other.valorCentavos == this.valorCentavos &&
          other.dataHora == this.dataHora &&
          other.observacao == this.observacao &&
          other.dataCriacao == this.dataCriacao &&
          other.dataAtualizacao == this.dataAtualizacao);
}

class DespesasVeiculoCompanion extends UpdateCompanion<DespesaVeiculo> {
  final Value<int> id;
  final Value<int> veiculoId;
  final Value<TipoDespesaVeiculo> tipo;
  final Value<String> descricao;
  final Value<int> valorCentavos;
  final Value<DateTime> dataHora;
  final Value<String?> observacao;
  final Value<DateTime> dataCriacao;
  final Value<DateTime?> dataAtualizacao;
  const DespesasVeiculoCompanion({
    this.id = const Value.absent(),
    this.veiculoId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.descricao = const Value.absent(),
    this.valorCentavos = const Value.absent(),
    this.dataHora = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  });
  DespesasVeiculoCompanion.insert({
    this.id = const Value.absent(),
    required int veiculoId,
    required TipoDespesaVeiculo tipo,
    required String descricao,
    required int valorCentavos,
    required DateTime dataHora,
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  }) : veiculoId = Value(veiculoId),
       tipo = Value(tipo),
       descricao = Value(descricao),
       valorCentavos = Value(valorCentavos),
       dataHora = Value(dataHora);
  static Insertable<DespesaVeiculo> custom({
    Expression<int>? id,
    Expression<int>? veiculoId,
    Expression<String>? tipo,
    Expression<String>? descricao,
    Expression<int>? valorCentavos,
    Expression<DateTime>? dataHora,
    Expression<String>? observacao,
    Expression<DateTime>? dataCriacao,
    Expression<DateTime>? dataAtualizacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (veiculoId != null) 'veiculo_id': veiculoId,
      if (tipo != null) 'tipo': tipo,
      if (descricao != null) 'descricao': descricao,
      if (valorCentavos != null) 'valor_centavos': valorCentavos,
      if (dataHora != null) 'data_hora': dataHora,
      if (observacao != null) 'observacao': observacao,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (dataAtualizacao != null) 'data_atualizacao': dataAtualizacao,
    });
  }

  DespesasVeiculoCompanion copyWith({
    Value<int>? id,
    Value<int>? veiculoId,
    Value<TipoDespesaVeiculo>? tipo,
    Value<String>? descricao,
    Value<int>? valorCentavos,
    Value<DateTime>? dataHora,
    Value<String?>? observacao,
    Value<DateTime>? dataCriacao,
    Value<DateTime?>? dataAtualizacao,
  }) {
    return DespesasVeiculoCompanion(
      id: id ?? this.id,
      veiculoId: veiculoId ?? this.veiculoId,
      tipo: tipo ?? this.tipo,
      descricao: descricao ?? this.descricao,
      valorCentavos: valorCentavos ?? this.valorCentavos,
      dataHora: dataHora ?? this.dataHora,
      observacao: observacao ?? this.observacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (veiculoId.present) {
      map['veiculo_id'] = Variable<int>(veiculoId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
        $DespesasVeiculoTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (valorCentavos.present) {
      map['valor_centavos'] = Variable<int>(valorCentavos.value);
    }
    if (dataHora.present) {
      map['data_hora'] = Variable<DateTime>(dataHora.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (dataAtualizacao.present) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DespesasVeiculoCompanion(')
          ..write('id: $id, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('tipo: $tipo, ')
          ..write('descricao: $descricao, ')
          ..write('valorCentavos: $valorCentavos, ')
          ..write('dataHora: $dataHora, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }
}

class $CustosRecorrentesTable extends CustosRecorrentes
    with TableInfo<$CustosRecorrentesTable, CustoRecorrente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustosRecorrentesTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<TipoCustoRecorrente, String>
  tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TipoCustoRecorrente>($CustosRecorrentesTable.$convertertipo);
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EscopoCustoRecorrente, String>
  escopo =
      GeneratedColumn<String>(
        'escopo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EscopoCustoRecorrente>(
        $CustosRecorrentesTable.$converterescopo,
      );
  static const VerificationMeta _veiculoIdMeta = const VerificationMeta(
    'veiculoId',
  );
  @override
  late final GeneratedColumn<int> veiculoId = GeneratedColumn<int>(
    'veiculo_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES veiculos (id)',
    ),
  );
  static const VerificationMeta _plataformaIdMeta = const VerificationMeta(
    'plataformaId',
  );
  @override
  late final GeneratedColumn<int> plataformaId = GeneratedColumn<int>(
    'plataforma_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plataformas (id)',
    ),
  );
  static const VerificationMeta _valorReferenciaCentavosMeta =
      const VerificationMeta('valorReferenciaCentavos');
  @override
  late final GeneratedColumn<int> valorReferenciaCentavos =
      GeneratedColumn<int>(
        'valor_referencia_centavos',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _valorEstimadoMeta = const VerificationMeta(
    'valorEstimado',
  );
  @override
  late final GeneratedColumn<bool> valorEstimado = GeneratedColumn<bool>(
    'valor_estimado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("valor_estimado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _periodicidadeMesesMeta =
      const VerificationMeta('periodicidadeMeses');
  @override
  late final GeneratedColumn<int> periodicidadeMeses = GeneratedColumn<int>(
    'periodicidade_meses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parcelasPorCicloMeta = const VerificationMeta(
    'parcelasPorCiclo',
  );
  @override
  late final GeneratedColumn<int> parcelasPorCiclo = GeneratedColumn<int>(
    'parcelas_por_ciclo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
  static const VerificationMeta _quantidadeCiclosPrevistaMeta =
      const VerificationMeta('quantidadeCiclosPrevista');
  @override
  late final GeneratedColumn<int> quantidadeCiclosPrevista =
      GeneratedColumn<int>(
        'quantidade_ciclos_prevista',
        aliasedName,
        true,
        type: DriftSqlType.int,
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
  static const VerificationMeta _dataAtualizacaoMeta = const VerificationMeta(
    'dataAtualizacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataAtualizacao =
      GeneratedColumn<DateTime>(
        'data_atualizacao',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipo,
    descricao,
    escopo,
    veiculoId,
    plataformaId,
    valorReferenciaCentavos,
    valorEstimado,
    periodicidadeMeses,
    parcelasPorCiclo,
    ativo,
    quantidadeCiclosPrevista,
    observacao,
    dataCriacao,
    dataAtualizacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custos_recorrentes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustoRecorrente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('veiculo_id')) {
      context.handle(
        _veiculoIdMeta,
        veiculoId.isAcceptableOrUnknown(data['veiculo_id']!, _veiculoIdMeta),
      );
    }
    if (data.containsKey('plataforma_id')) {
      context.handle(
        _plataformaIdMeta,
        plataformaId.isAcceptableOrUnknown(
          data['plataforma_id']!,
          _plataformaIdMeta,
        ),
      );
    }
    if (data.containsKey('valor_referencia_centavos')) {
      context.handle(
        _valorReferenciaCentavosMeta,
        valorReferenciaCentavos.isAcceptableOrUnknown(
          data['valor_referencia_centavos']!,
          _valorReferenciaCentavosMeta,
        ),
      );
    }
    if (data.containsKey('valor_estimado')) {
      context.handle(
        _valorEstimadoMeta,
        valorEstimado.isAcceptableOrUnknown(
          data['valor_estimado']!,
          _valorEstimadoMeta,
        ),
      );
    }
    if (data.containsKey('periodicidade_meses')) {
      context.handle(
        _periodicidadeMesesMeta,
        periodicidadeMeses.isAcceptableOrUnknown(
          data['periodicidade_meses']!,
          _periodicidadeMesesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodicidadeMesesMeta);
    }
    if (data.containsKey('parcelas_por_ciclo')) {
      context.handle(
        _parcelasPorCicloMeta,
        parcelasPorCiclo.isAcceptableOrUnknown(
          data['parcelas_por_ciclo']!,
          _parcelasPorCicloMeta,
        ),
      );
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    if (data.containsKey('quantidade_ciclos_prevista')) {
      context.handle(
        _quantidadeCiclosPrevistaMeta,
        quantidadeCiclosPrevista.isAcceptableOrUnknown(
          data['quantidade_ciclos_prevista']!,
          _quantidadeCiclosPrevistaMeta,
        ),
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
    if (data.containsKey('data_atualizacao')) {
      context.handle(
        _dataAtualizacaoMeta,
        dataAtualizacao.isAcceptableOrUnknown(
          data['data_atualizacao']!,
          _dataAtualizacaoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustoRecorrente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustoRecorrente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tipo: $CustosRecorrentesTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      )!,
      escopo: $CustosRecorrentesTable.$converterescopo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}escopo'],
        )!,
      ),
      veiculoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}veiculo_id'],
      ),
      plataformaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plataforma_id'],
      ),
      valorReferenciaCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_referencia_centavos'],
      ),
      valorEstimado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}valor_estimado'],
      )!,
      periodicidadeMeses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}periodicidade_meses'],
      )!,
      parcelasPorCiclo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parcelas_por_ciclo'],
      )!,
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
      quantidadeCiclosPrevista: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantidade_ciclos_prevista'],
      ),
      observacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacao'],
      ),
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      dataAtualizacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_atualizacao'],
      ),
    );
  }

  @override
  $CustosRecorrentesTable createAlias(String alias) {
    return $CustosRecorrentesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoCustoRecorrente, String, String>
  $convertertipo = const EnumNameConverter<TipoCustoRecorrente>(
    TipoCustoRecorrente.values,
  );
  static JsonTypeConverter2<EscopoCustoRecorrente, String, String>
  $converterescopo = const EnumNameConverter<EscopoCustoRecorrente>(
    EscopoCustoRecorrente.values,
  );
}

class CustoRecorrente extends DataClass implements Insertable<CustoRecorrente> {
  final int id;
  final TipoCustoRecorrente tipo;
  final String descricao;
  final EscopoCustoRecorrente escopo;
  final int? veiculoId;
  final int? plataformaId;
  final int? valorReferenciaCentavos;
  final bool valorEstimado;
  final int periodicidadeMeses;
  final int parcelasPorCiclo;
  final bool ativo;
  final int? quantidadeCiclosPrevista;
  final String? observacao;
  final DateTime dataCriacao;
  final DateTime? dataAtualizacao;
  const CustoRecorrente({
    required this.id,
    required this.tipo,
    required this.descricao,
    required this.escopo,
    this.veiculoId,
    this.plataformaId,
    this.valorReferenciaCentavos,
    required this.valorEstimado,
    required this.periodicidadeMeses,
    required this.parcelasPorCiclo,
    required this.ativo,
    this.quantidadeCiclosPrevista,
    this.observacao,
    required this.dataCriacao,
    this.dataAtualizacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['tipo'] = Variable<String>(
        $CustosRecorrentesTable.$convertertipo.toSql(tipo),
      );
    }
    map['descricao'] = Variable<String>(descricao);
    {
      map['escopo'] = Variable<String>(
        $CustosRecorrentesTable.$converterescopo.toSql(escopo),
      );
    }
    if (!nullToAbsent || veiculoId != null) {
      map['veiculo_id'] = Variable<int>(veiculoId);
    }
    if (!nullToAbsent || plataformaId != null) {
      map['plataforma_id'] = Variable<int>(plataformaId);
    }
    if (!nullToAbsent || valorReferenciaCentavos != null) {
      map['valor_referencia_centavos'] = Variable<int>(valorReferenciaCentavos);
    }
    map['valor_estimado'] = Variable<bool>(valorEstimado);
    map['periodicidade_meses'] = Variable<int>(periodicidadeMeses);
    map['parcelas_por_ciclo'] = Variable<int>(parcelasPorCiclo);
    map['ativo'] = Variable<bool>(ativo);
    if (!nullToAbsent || quantidadeCiclosPrevista != null) {
      map['quantidade_ciclos_prevista'] = Variable<int>(
        quantidadeCiclosPrevista,
      );
    }
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
    }
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    if (!nullToAbsent || dataAtualizacao != null) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao);
    }
    return map;
  }

  CustosRecorrentesCompanion toCompanion(bool nullToAbsent) {
    return CustosRecorrentesCompanion(
      id: Value(id),
      tipo: Value(tipo),
      descricao: Value(descricao),
      escopo: Value(escopo),
      veiculoId: veiculoId == null && nullToAbsent
          ? const Value.absent()
          : Value(veiculoId),
      plataformaId: plataformaId == null && nullToAbsent
          ? const Value.absent()
          : Value(plataformaId),
      valorReferenciaCentavos: valorReferenciaCentavos == null && nullToAbsent
          ? const Value.absent()
          : Value(valorReferenciaCentavos),
      valorEstimado: Value(valorEstimado),
      periodicidadeMeses: Value(periodicidadeMeses),
      parcelasPorCiclo: Value(parcelasPorCiclo),
      ativo: Value(ativo),
      quantidadeCiclosPrevista: quantidadeCiclosPrevista == null && nullToAbsent
          ? const Value.absent()
          : Value(quantidadeCiclosPrevista),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
      dataCriacao: Value(dataCriacao),
      dataAtualizacao: dataAtualizacao == null && nullToAbsent
          ? const Value.absent()
          : Value(dataAtualizacao),
    );
  }

  factory CustoRecorrente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustoRecorrente(
      id: serializer.fromJson<int>(json['id']),
      tipo: $CustosRecorrentesTable.$convertertipo.fromJson(
        serializer.fromJson<String>(json['tipo']),
      ),
      descricao: serializer.fromJson<String>(json['descricao']),
      escopo: $CustosRecorrentesTable.$converterescopo.fromJson(
        serializer.fromJson<String>(json['escopo']),
      ),
      veiculoId: serializer.fromJson<int?>(json['veiculoId']),
      plataformaId: serializer.fromJson<int?>(json['plataformaId']),
      valorReferenciaCentavos: serializer.fromJson<int?>(
        json['valorReferenciaCentavos'],
      ),
      valorEstimado: serializer.fromJson<bool>(json['valorEstimado']),
      periodicidadeMeses: serializer.fromJson<int>(json['periodicidadeMeses']),
      parcelasPorCiclo: serializer.fromJson<int>(json['parcelasPorCiclo']),
      ativo: serializer.fromJson<bool>(json['ativo']),
      quantidadeCiclosPrevista: serializer.fromJson<int?>(
        json['quantidadeCiclosPrevista'],
      ),
      observacao: serializer.fromJson<String?>(json['observacao']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      dataAtualizacao: serializer.fromJson<DateTime?>(json['dataAtualizacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipo': serializer.toJson<String>(
        $CustosRecorrentesTable.$convertertipo.toJson(tipo),
      ),
      'descricao': serializer.toJson<String>(descricao),
      'escopo': serializer.toJson<String>(
        $CustosRecorrentesTable.$converterescopo.toJson(escopo),
      ),
      'veiculoId': serializer.toJson<int?>(veiculoId),
      'plataformaId': serializer.toJson<int?>(plataformaId),
      'valorReferenciaCentavos': serializer.toJson<int?>(
        valorReferenciaCentavos,
      ),
      'valorEstimado': serializer.toJson<bool>(valorEstimado),
      'periodicidadeMeses': serializer.toJson<int>(periodicidadeMeses),
      'parcelasPorCiclo': serializer.toJson<int>(parcelasPorCiclo),
      'ativo': serializer.toJson<bool>(ativo),
      'quantidadeCiclosPrevista': serializer.toJson<int?>(
        quantidadeCiclosPrevista,
      ),
      'observacao': serializer.toJson<String?>(observacao),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'dataAtualizacao': serializer.toJson<DateTime?>(dataAtualizacao),
    };
  }

  CustoRecorrente copyWith({
    int? id,
    TipoCustoRecorrente? tipo,
    String? descricao,
    EscopoCustoRecorrente? escopo,
    Value<int?> veiculoId = const Value.absent(),
    Value<int?> plataformaId = const Value.absent(),
    Value<int?> valorReferenciaCentavos = const Value.absent(),
    bool? valorEstimado,
    int? periodicidadeMeses,
    int? parcelasPorCiclo,
    bool? ativo,
    Value<int?> quantidadeCiclosPrevista = const Value.absent(),
    Value<String?> observacao = const Value.absent(),
    DateTime? dataCriacao,
    Value<DateTime?> dataAtualizacao = const Value.absent(),
  }) => CustoRecorrente(
    id: id ?? this.id,
    tipo: tipo ?? this.tipo,
    descricao: descricao ?? this.descricao,
    escopo: escopo ?? this.escopo,
    veiculoId: veiculoId.present ? veiculoId.value : this.veiculoId,
    plataformaId: plataformaId.present ? plataformaId.value : this.plataformaId,
    valorReferenciaCentavos: valorReferenciaCentavos.present
        ? valorReferenciaCentavos.value
        : this.valorReferenciaCentavos,
    valorEstimado: valorEstimado ?? this.valorEstimado,
    periodicidadeMeses: periodicidadeMeses ?? this.periodicidadeMeses,
    parcelasPorCiclo: parcelasPorCiclo ?? this.parcelasPorCiclo,
    ativo: ativo ?? this.ativo,
    quantidadeCiclosPrevista: quantidadeCiclosPrevista.present
        ? quantidadeCiclosPrevista.value
        : this.quantidadeCiclosPrevista,
    observacao: observacao.present ? observacao.value : this.observacao,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    dataAtualizacao: dataAtualizacao.present
        ? dataAtualizacao.value
        : this.dataAtualizacao,
  );
  CustoRecorrente copyWithCompanion(CustosRecorrentesCompanion data) {
    return CustoRecorrente(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      escopo: data.escopo.present ? data.escopo.value : this.escopo,
      veiculoId: data.veiculoId.present ? data.veiculoId.value : this.veiculoId,
      plataformaId: data.plataformaId.present
          ? data.plataformaId.value
          : this.plataformaId,
      valorReferenciaCentavos: data.valorReferenciaCentavos.present
          ? data.valorReferenciaCentavos.value
          : this.valorReferenciaCentavos,
      valorEstimado: data.valorEstimado.present
          ? data.valorEstimado.value
          : this.valorEstimado,
      periodicidadeMeses: data.periodicidadeMeses.present
          ? data.periodicidadeMeses.value
          : this.periodicidadeMeses,
      parcelasPorCiclo: data.parcelasPorCiclo.present
          ? data.parcelasPorCiclo.value
          : this.parcelasPorCiclo,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
      quantidadeCiclosPrevista: data.quantidadeCiclosPrevista.present
          ? data.quantidadeCiclosPrevista.value
          : this.quantidadeCiclosPrevista,
      observacao: data.observacao.present
          ? data.observacao.value
          : this.observacao,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      dataAtualizacao: data.dataAtualizacao.present
          ? data.dataAtualizacao.value
          : this.dataAtualizacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustoRecorrente(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('descricao: $descricao, ')
          ..write('escopo: $escopo, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('plataformaId: $plataformaId, ')
          ..write('valorReferenciaCentavos: $valorReferenciaCentavos, ')
          ..write('valorEstimado: $valorEstimado, ')
          ..write('periodicidadeMeses: $periodicidadeMeses, ')
          ..write('parcelasPorCiclo: $parcelasPorCiclo, ')
          ..write('ativo: $ativo, ')
          ..write('quantidadeCiclosPrevista: $quantidadeCiclosPrevista, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipo,
    descricao,
    escopo,
    veiculoId,
    plataformaId,
    valorReferenciaCentavos,
    valorEstimado,
    periodicidadeMeses,
    parcelasPorCiclo,
    ativo,
    quantidadeCiclosPrevista,
    observacao,
    dataCriacao,
    dataAtualizacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustoRecorrente &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.descricao == this.descricao &&
          other.escopo == this.escopo &&
          other.veiculoId == this.veiculoId &&
          other.plataformaId == this.plataformaId &&
          other.valorReferenciaCentavos == this.valorReferenciaCentavos &&
          other.valorEstimado == this.valorEstimado &&
          other.periodicidadeMeses == this.periodicidadeMeses &&
          other.parcelasPorCiclo == this.parcelasPorCiclo &&
          other.ativo == this.ativo &&
          other.quantidadeCiclosPrevista == this.quantidadeCiclosPrevista &&
          other.observacao == this.observacao &&
          other.dataCriacao == this.dataCriacao &&
          other.dataAtualizacao == this.dataAtualizacao);
}

class CustosRecorrentesCompanion extends UpdateCompanion<CustoRecorrente> {
  final Value<int> id;
  final Value<TipoCustoRecorrente> tipo;
  final Value<String> descricao;
  final Value<EscopoCustoRecorrente> escopo;
  final Value<int?> veiculoId;
  final Value<int?> plataformaId;
  final Value<int?> valorReferenciaCentavos;
  final Value<bool> valorEstimado;
  final Value<int> periodicidadeMeses;
  final Value<int> parcelasPorCiclo;
  final Value<bool> ativo;
  final Value<int?> quantidadeCiclosPrevista;
  final Value<String?> observacao;
  final Value<DateTime> dataCriacao;
  final Value<DateTime?> dataAtualizacao;
  const CustosRecorrentesCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.descricao = const Value.absent(),
    this.escopo = const Value.absent(),
    this.veiculoId = const Value.absent(),
    this.plataformaId = const Value.absent(),
    this.valorReferenciaCentavos = const Value.absent(),
    this.valorEstimado = const Value.absent(),
    this.periodicidadeMeses = const Value.absent(),
    this.parcelasPorCiclo = const Value.absent(),
    this.ativo = const Value.absent(),
    this.quantidadeCiclosPrevista = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  });
  CustosRecorrentesCompanion.insert({
    this.id = const Value.absent(),
    required TipoCustoRecorrente tipo,
    required String descricao,
    required EscopoCustoRecorrente escopo,
    this.veiculoId = const Value.absent(),
    this.plataformaId = const Value.absent(),
    this.valorReferenciaCentavos = const Value.absent(),
    this.valorEstimado = const Value.absent(),
    required int periodicidadeMeses,
    this.parcelasPorCiclo = const Value.absent(),
    this.ativo = const Value.absent(),
    this.quantidadeCiclosPrevista = const Value.absent(),
    this.observacao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  }) : tipo = Value(tipo),
       descricao = Value(descricao),
       escopo = Value(escopo),
       periodicidadeMeses = Value(periodicidadeMeses);
  static Insertable<CustoRecorrente> custom({
    Expression<int>? id,
    Expression<String>? tipo,
    Expression<String>? descricao,
    Expression<String>? escopo,
    Expression<int>? veiculoId,
    Expression<int>? plataformaId,
    Expression<int>? valorReferenciaCentavos,
    Expression<bool>? valorEstimado,
    Expression<int>? periodicidadeMeses,
    Expression<int>? parcelasPorCiclo,
    Expression<bool>? ativo,
    Expression<int>? quantidadeCiclosPrevista,
    Expression<String>? observacao,
    Expression<DateTime>? dataCriacao,
    Expression<DateTime>? dataAtualizacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (descricao != null) 'descricao': descricao,
      if (escopo != null) 'escopo': escopo,
      if (veiculoId != null) 'veiculo_id': veiculoId,
      if (plataformaId != null) 'plataforma_id': plataformaId,
      if (valorReferenciaCentavos != null)
        'valor_referencia_centavos': valorReferenciaCentavos,
      if (valorEstimado != null) 'valor_estimado': valorEstimado,
      if (periodicidadeMeses != null) 'periodicidade_meses': periodicidadeMeses,
      if (parcelasPorCiclo != null) 'parcelas_por_ciclo': parcelasPorCiclo,
      if (ativo != null) 'ativo': ativo,
      if (quantidadeCiclosPrevista != null)
        'quantidade_ciclos_prevista': quantidadeCiclosPrevista,
      if (observacao != null) 'observacao': observacao,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (dataAtualizacao != null) 'data_atualizacao': dataAtualizacao,
    });
  }

  CustosRecorrentesCompanion copyWith({
    Value<int>? id,
    Value<TipoCustoRecorrente>? tipo,
    Value<String>? descricao,
    Value<EscopoCustoRecorrente>? escopo,
    Value<int?>? veiculoId,
    Value<int?>? plataformaId,
    Value<int?>? valorReferenciaCentavos,
    Value<bool>? valorEstimado,
    Value<int>? periodicidadeMeses,
    Value<int>? parcelasPorCiclo,
    Value<bool>? ativo,
    Value<int?>? quantidadeCiclosPrevista,
    Value<String?>? observacao,
    Value<DateTime>? dataCriacao,
    Value<DateTime?>? dataAtualizacao,
  }) {
    return CustosRecorrentesCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      descricao: descricao ?? this.descricao,
      escopo: escopo ?? this.escopo,
      veiculoId: veiculoId ?? this.veiculoId,
      plataformaId: plataformaId ?? this.plataformaId,
      valorReferenciaCentavos:
          valorReferenciaCentavos ?? this.valorReferenciaCentavos,
      valorEstimado: valorEstimado ?? this.valorEstimado,
      periodicidadeMeses: periodicidadeMeses ?? this.periodicidadeMeses,
      parcelasPorCiclo: parcelasPorCiclo ?? this.parcelasPorCiclo,
      ativo: ativo ?? this.ativo,
      quantidadeCiclosPrevista:
          quantidadeCiclosPrevista ?? this.quantidadeCiclosPrevista,
      observacao: observacao ?? this.observacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
        $CustosRecorrentesTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (escopo.present) {
      map['escopo'] = Variable<String>(
        $CustosRecorrentesTable.$converterescopo.toSql(escopo.value),
      );
    }
    if (veiculoId.present) {
      map['veiculo_id'] = Variable<int>(veiculoId.value);
    }
    if (plataformaId.present) {
      map['plataforma_id'] = Variable<int>(plataformaId.value);
    }
    if (valorReferenciaCentavos.present) {
      map['valor_referencia_centavos'] = Variable<int>(
        valorReferenciaCentavos.value,
      );
    }
    if (valorEstimado.present) {
      map['valor_estimado'] = Variable<bool>(valorEstimado.value);
    }
    if (periodicidadeMeses.present) {
      map['periodicidade_meses'] = Variable<int>(periodicidadeMeses.value);
    }
    if (parcelasPorCiclo.present) {
      map['parcelas_por_ciclo'] = Variable<int>(parcelasPorCiclo.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (quantidadeCiclosPrevista.present) {
      map['quantidade_ciclos_prevista'] = Variable<int>(
        quantidadeCiclosPrevista.value,
      );
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (dataAtualizacao.present) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustosRecorrentesCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('descricao: $descricao, ')
          ..write('escopo: $escopo, ')
          ..write('veiculoId: $veiculoId, ')
          ..write('plataformaId: $plataformaId, ')
          ..write('valorReferenciaCentavos: $valorReferenciaCentavos, ')
          ..write('valorEstimado: $valorEstimado, ')
          ..write('periodicidadeMeses: $periodicidadeMeses, ')
          ..write('parcelasPorCiclo: $parcelasPorCiclo, ')
          ..write('ativo: $ativo, ')
          ..write('quantidadeCiclosPrevista: $quantidadeCiclosPrevista, ')
          ..write('observacao: $observacao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
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
  late final $LeiturasGanhosTable leiturasGanhos = $LeiturasGanhosTable(this);
  late final $LeiturasGanhoPlataformaTable leiturasGanhoPlataforma =
      $LeiturasGanhoPlataformaTable(this);
  late final $LancamentosGanhoIndividualTable lancamentosGanhoIndividual =
      $LancamentosGanhoIndividualTable(this);
  late final $AbastecimentosTable abastecimentos = $AbastecimentosTable(this);
  late final $PassesPlataformaTable passesPlataforma = $PassesPlataformaTable(
    this,
  );
  late final $BonusPromocoesTable bonusPromocoes = $BonusPromocoesTable(this);
  late final $ManutencoesTable manutencoes = $ManutencoesTable(this);
  late final $ItensManutencaoTable itensManutencao = $ItensManutencaoTable(
    this,
  );
  late final $DespesasVeiculoTable despesasVeiculo = $DespesasVeiculoTable(
    this,
  );
  late final $CustosRecorrentesTable custosRecorrentes =
      $CustosRecorrentesTable(this);
  late final JornadaDao jornadaDao = JornadaDao(this as AppDatabase);
  late final PausaDao pausaDao = PausaDao(this as AppDatabase);
  late final LeituraGanhosDao leituraGanhosDao = LeituraGanhosDao(
    this as AppDatabase,
  );
  late final GanhoIndividualDao ganhoIndividualDao = GanhoIndividualDao(
    this as AppDatabase,
  );
  late final AbastecimentoDao abastecimentoDao = AbastecimentoDao(
    this as AppDatabase,
  );
  late final PassePlataformaDao passePlataformaDao = PassePlataformaDao(
    this as AppDatabase,
  );
  late final BonusPromocaoDao bonusPromocaoDao = BonusPromocaoDao(
    this as AppDatabase,
  );
  late final ManutencaoDao manutencaoDao = ManutencaoDao(this as AppDatabase);
  late final DespesaVeiculoDao despesaVeiculoDao = DespesaVeiculoDao(
    this as AppDatabase,
  );
  late final CustoRecorrenteDao custoRecorrenteDao = CustoRecorrenteDao(
    this as AppDatabase,
  );
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
    leiturasGanhos,
    leiturasGanhoPlataforma,
    lancamentosGanhoIndividual,
    abastecimentos,
    passesPlataforma,
    bonusPromocoes,
    manutencoes,
    itensManutencao,
    despesasVeiculo,
    custosRecorrentes,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'manutencoes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('itens_manutencao', kind: UpdateKind.delete)],
    ),
  ]);
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

  static MultiTypedResultKey<$AbastecimentosTable, List<Abastecimento>>
  _abastecimentosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.abastecimentos,
    aliasName: 'veiculos__id__abastecimentos__veiculo_id',
  );

  $$AbastecimentosTableProcessedTableManager get abastecimentosRefs {
    final manager = $$AbastecimentosTableTableManager(
      $_db,
      $_db.abastecimentos,
    ).filter((f) => f.veiculoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_abastecimentosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ManutencoesTable, List<Manutencao>>
  _manutencoesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.manutencoes,
    aliasName: 'veiculos__id__manutencoes__veiculo_id',
  );

  $$ManutencoesTableProcessedTableManager get manutencoesRefs {
    final manager = $$ManutencoesTableTableManager(
      $_db,
      $_db.manutencoes,
    ).filter((f) => f.veiculoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_manutencoesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DespesasVeiculoTable, List<DespesaVeiculo>>
  _despesasVeiculoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.despesasVeiculo,
    aliasName: 'veiculos__id__despesas_veiculo__veiculo_id',
  );

  $$DespesasVeiculoTableProcessedTableManager get despesasVeiculoRefs {
    final manager = $$DespesasVeiculoTableTableManager(
      $_db,
      $_db.despesasVeiculo,
    ).filter((f) => f.veiculoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _despesasVeiculoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CustosRecorrentesTable, List<CustoRecorrente>>
  _custosRecorrentesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.custosRecorrentes,
        aliasName: 'veiculos__id__custos_recorrentes__veiculo_id',
      );

  $$CustosRecorrentesTableProcessedTableManager get custosRecorrentesRefs {
    final manager = $$CustosRecorrentesTableTableManager(
      $_db,
      $_db.custosRecorrentes,
    ).filter((f) => f.veiculoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _custosRecorrentesRefsTable($_db),
    );
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

  Expression<bool> abastecimentosRefs(
    Expression<bool> Function($$AbastecimentosTableFilterComposer f) f,
  ) {
    final $$AbastecimentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.abastecimentos,
      getReferencedColumn: (t) => t.veiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbastecimentosTableFilterComposer(
            $db: $db,
            $table: $db.abastecimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> manutencoesRefs(
    Expression<bool> Function($$ManutencoesTableFilterComposer f) f,
  ) {
    final $$ManutencoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.manutencoes,
      getReferencedColumn: (t) => t.veiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ManutencoesTableFilterComposer(
            $db: $db,
            $table: $db.manutencoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> despesasVeiculoRefs(
    Expression<bool> Function($$DespesasVeiculoTableFilterComposer f) f,
  ) {
    final $$DespesasVeiculoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.despesasVeiculo,
      getReferencedColumn: (t) => t.veiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DespesasVeiculoTableFilterComposer(
            $db: $db,
            $table: $db.despesasVeiculo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> custosRecorrentesRefs(
    Expression<bool> Function($$CustosRecorrentesTableFilterComposer f) f,
  ) {
    final $$CustosRecorrentesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.custosRecorrentes,
      getReferencedColumn: (t) => t.veiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustosRecorrentesTableFilterComposer(
            $db: $db,
            $table: $db.custosRecorrentes,
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

  Expression<T> abastecimentosRefs<T extends Object>(
    Expression<T> Function($$AbastecimentosTableAnnotationComposer a) f,
  ) {
    final $$AbastecimentosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.abastecimentos,
      getReferencedColumn: (t) => t.veiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbastecimentosTableAnnotationComposer(
            $db: $db,
            $table: $db.abastecimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> manutencoesRefs<T extends Object>(
    Expression<T> Function($$ManutencoesTableAnnotationComposer a) f,
  ) {
    final $$ManutencoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.manutencoes,
      getReferencedColumn: (t) => t.veiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ManutencoesTableAnnotationComposer(
            $db: $db,
            $table: $db.manutencoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> despesasVeiculoRefs<T extends Object>(
    Expression<T> Function($$DespesasVeiculoTableAnnotationComposer a) f,
  ) {
    final $$DespesasVeiculoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.despesasVeiculo,
      getReferencedColumn: (t) => t.veiculoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DespesasVeiculoTableAnnotationComposer(
            $db: $db,
            $table: $db.despesasVeiculo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> custosRecorrentesRefs<T extends Object>(
    Expression<T> Function($$CustosRecorrentesTableAnnotationComposer a) f,
  ) {
    final $$CustosRecorrentesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.custosRecorrentes,
          getReferencedColumn: (t) => t.veiculoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CustosRecorrentesTableAnnotationComposer(
                $db: $db,
                $table: $db.custosRecorrentes,
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
          PrefetchHooks Function({
            bool jornadasRefs,
            bool abastecimentosRefs,
            bool manutencoesRefs,
            bool despesasVeiculoRefs,
            bool custosRecorrentesRefs,
          })
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
          prefetchHooksCallback:
              ({
                jornadasRefs = false,
                abastecimentosRefs = false,
                manutencoesRefs = false,
                despesasVeiculoRefs = false,
                custosRecorrentesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (jornadasRefs) db.jornadas,
                    if (abastecimentosRefs) db.abastecimentos,
                    if (manutencoesRefs) db.manutencoes,
                    if (despesasVeiculoRefs) db.despesasVeiculo,
                    if (custosRecorrentesRefs) db.custosRecorrentes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (jornadasRefs)
                        await $_getPrefetchedData<
                          Veiculo,
                          $VeiculosTable,
                          Jornada
                        >(
                          currentTable: table,
                          referencedTable: $$VeiculosTableReferences
                              ._jornadasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VeiculosTableReferences(
                                db,
                                table,
                                p0,
                              ).jornadasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.veiculoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (abastecimentosRefs)
                        await $_getPrefetchedData<
                          Veiculo,
                          $VeiculosTable,
                          Abastecimento
                        >(
                          currentTable: table,
                          referencedTable: $$VeiculosTableReferences
                              ._abastecimentosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VeiculosTableReferences(
                                db,
                                table,
                                p0,
                              ).abastecimentosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.veiculoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (manutencoesRefs)
                        await $_getPrefetchedData<
                          Veiculo,
                          $VeiculosTable,
                          Manutencao
                        >(
                          currentTable: table,
                          referencedTable: $$VeiculosTableReferences
                              ._manutencoesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VeiculosTableReferences(
                                db,
                                table,
                                p0,
                              ).manutencoesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.veiculoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (despesasVeiculoRefs)
                        await $_getPrefetchedData<
                          Veiculo,
                          $VeiculosTable,
                          DespesaVeiculo
                        >(
                          currentTable: table,
                          referencedTable: $$VeiculosTableReferences
                              ._despesasVeiculoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VeiculosTableReferences(
                                db,
                                table,
                                p0,
                              ).despesasVeiculoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.veiculoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (custosRecorrentesRefs)
                        await $_getPrefetchedData<
                          Veiculo,
                          $VeiculosTable,
                          CustoRecorrente
                        >(
                          currentTable: table,
                          referencedTable: $$VeiculosTableReferences
                              ._custosRecorrentesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VeiculosTableReferences(
                                db,
                                table,
                                p0,
                              ).custosRecorrentesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.veiculoId == item.id,
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
      PrefetchHooks Function({
        bool jornadasRefs,
        bool abastecimentosRefs,
        bool manutencoesRefs,
        bool despesasVeiculoRefs,
        bool custosRecorrentesRefs,
      })
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

  static MultiTypedResultKey<$LeiturasGanhosTable, List<LeiturasGanho>>
  _leiturasGanhosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.leiturasGanhos,
    aliasName: 'jornadas__id__leituras_ganhos__jornada_id',
  );

  $$LeiturasGanhosTableProcessedTableManager get leiturasGanhosRefs {
    final manager = $$LeiturasGanhosTableTableManager(
      $_db,
      $_db.leiturasGanhos,
    ).filter((f) => f.jornadaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_leiturasGanhosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LancamentosGanhoIndividualTable,
    List<LancamentosGanhoIndividualData>
  >
  _lancamentosGanhoIndividualRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.lancamentosGanhoIndividual,
        aliasName: 'jornadas__id__lancamentos_ganho_individual__jornada_id',
      );

  $$LancamentosGanhoIndividualTableProcessedTableManager
  get lancamentosGanhoIndividualRefs {
    final manager = $$LancamentosGanhoIndividualTableTableManager(
      $_db,
      $_db.lancamentosGanhoIndividual,
    ).filter((f) => f.jornadaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _lancamentosGanhoIndividualRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AbastecimentosTable, List<Abastecimento>>
  _abastecimentosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.abastecimentos,
    aliasName: 'jornadas__id__abastecimentos__jornada_id',
  );

  $$AbastecimentosTableProcessedTableManager get abastecimentosRefs {
    final manager = $$AbastecimentosTableTableManager(
      $_db,
      $_db.abastecimentos,
    ).filter((f) => f.jornadaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_abastecimentosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PassesPlataformaTable, List<PassesPlataformaData>>
  _passesPlataformaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.passesPlataforma,
    aliasName: 'jornadas__id__passes_plataforma__jornada_id',
  );

  $$PassesPlataformaTableProcessedTableManager get passesPlataformaRefs {
    final manager = $$PassesPlataformaTableTableManager(
      $_db,
      $_db.passesPlataforma,
    ).filter((f) => f.jornadaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _passesPlataformaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BonusPromocoesTable, List<BonusPromocao>>
  _bonusPromocoesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bonusPromocoes,
    aliasName: 'jornadas__id__bonus_promocoes__jornada_id',
  );

  $$BonusPromocoesTableProcessedTableManager get bonusPromocoesRefs {
    final manager = $$BonusPromocoesTableTableManager(
      $_db,
      $_db.bonusPromocoes,
    ).filter((f) => f.jornadaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bonusPromocoesRefsTable($_db));
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

  Expression<bool> leiturasGanhosRefs(
    Expression<bool> Function($$LeiturasGanhosTableFilterComposer f) f,
  ) {
    final $$LeiturasGanhosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leiturasGanhos,
      getReferencedColumn: (t) => t.jornadaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeiturasGanhosTableFilterComposer(
            $db: $db,
            $table: $db.leiturasGanhos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> lancamentosGanhoIndividualRefs(
    Expression<bool> Function($$LancamentosGanhoIndividualTableFilterComposer f)
    f,
  ) {
    final $$LancamentosGanhoIndividualTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.lancamentosGanhoIndividual,
          getReferencedColumn: (t) => t.jornadaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LancamentosGanhoIndividualTableFilterComposer(
                $db: $db,
                $table: $db.lancamentosGanhoIndividual,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> abastecimentosRefs(
    Expression<bool> Function($$AbastecimentosTableFilterComposer f) f,
  ) {
    final $$AbastecimentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.abastecimentos,
      getReferencedColumn: (t) => t.jornadaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbastecimentosTableFilterComposer(
            $db: $db,
            $table: $db.abastecimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> passesPlataformaRefs(
    Expression<bool> Function($$PassesPlataformaTableFilterComposer f) f,
  ) {
    final $$PassesPlataformaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.passesPlataforma,
      getReferencedColumn: (t) => t.jornadaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PassesPlataformaTableFilterComposer(
            $db: $db,
            $table: $db.passesPlataforma,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bonusPromocoesRefs(
    Expression<bool> Function($$BonusPromocoesTableFilterComposer f) f,
  ) {
    final $$BonusPromocoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bonusPromocoes,
      getReferencedColumn: (t) => t.jornadaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BonusPromocoesTableFilterComposer(
            $db: $db,
            $table: $db.bonusPromocoes,
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

  Expression<T> leiturasGanhosRefs<T extends Object>(
    Expression<T> Function($$LeiturasGanhosTableAnnotationComposer a) f,
  ) {
    final $$LeiturasGanhosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leiturasGanhos,
      getReferencedColumn: (t) => t.jornadaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeiturasGanhosTableAnnotationComposer(
            $db: $db,
            $table: $db.leiturasGanhos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> lancamentosGanhoIndividualRefs<T extends Object>(
    Expression<T> Function(
      $$LancamentosGanhoIndividualTableAnnotationComposer a,
    )
    f,
  ) {
    final $$LancamentosGanhoIndividualTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.lancamentosGanhoIndividual,
          getReferencedColumn: (t) => t.jornadaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LancamentosGanhoIndividualTableAnnotationComposer(
                $db: $db,
                $table: $db.lancamentosGanhoIndividual,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> abastecimentosRefs<T extends Object>(
    Expression<T> Function($$AbastecimentosTableAnnotationComposer a) f,
  ) {
    final $$AbastecimentosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.abastecimentos,
      getReferencedColumn: (t) => t.jornadaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbastecimentosTableAnnotationComposer(
            $db: $db,
            $table: $db.abastecimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> passesPlataformaRefs<T extends Object>(
    Expression<T> Function($$PassesPlataformaTableAnnotationComposer a) f,
  ) {
    final $$PassesPlataformaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.passesPlataforma,
      getReferencedColumn: (t) => t.jornadaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PassesPlataformaTableAnnotationComposer(
            $db: $db,
            $table: $db.passesPlataforma,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bonusPromocoesRefs<T extends Object>(
    Expression<T> Function($$BonusPromocoesTableAnnotationComposer a) f,
  ) {
    final $$BonusPromocoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bonusPromocoes,
      getReferencedColumn: (t) => t.jornadaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BonusPromocoesTableAnnotationComposer(
            $db: $db,
            $table: $db.bonusPromocoes,
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
            bool leiturasGanhosRefs,
            bool lancamentosGanhoIndividualRefs,
            bool abastecimentosRefs,
            bool passesPlataformaRefs,
            bool bonusPromocoesRefs,
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
              ({
                usuarioId = false,
                veiculoId = false,
                pausasRefs = false,
                leiturasGanhosRefs = false,
                lancamentosGanhoIndividualRefs = false,
                abastecimentosRefs = false,
                passesPlataformaRefs = false,
                bonusPromocoesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (pausasRefs) db.pausas,
                    if (leiturasGanhosRefs) db.leiturasGanhos,
                    if (lancamentosGanhoIndividualRefs)
                      db.lancamentosGanhoIndividual,
                    if (abastecimentosRefs) db.abastecimentos,
                    if (passesPlataformaRefs) db.passesPlataforma,
                    if (bonusPromocoesRefs) db.bonusPromocoes,
                  ],
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
                      if (leiturasGanhosRefs)
                        await $_getPrefetchedData<
                          Jornada,
                          $JornadasTable,
                          LeiturasGanho
                        >(
                          currentTable: table,
                          referencedTable: $$JornadasTableReferences
                              ._leiturasGanhosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JornadasTableReferences(
                                db,
                                table,
                                p0,
                              ).leiturasGanhosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jornadaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (lancamentosGanhoIndividualRefs)
                        await $_getPrefetchedData<
                          Jornada,
                          $JornadasTable,
                          LancamentosGanhoIndividualData
                        >(
                          currentTable: table,
                          referencedTable: $$JornadasTableReferences
                              ._lancamentosGanhoIndividualRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JornadasTableReferences(
                                db,
                                table,
                                p0,
                              ).lancamentosGanhoIndividualRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jornadaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (abastecimentosRefs)
                        await $_getPrefetchedData<
                          Jornada,
                          $JornadasTable,
                          Abastecimento
                        >(
                          currentTable: table,
                          referencedTable: $$JornadasTableReferences
                              ._abastecimentosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JornadasTableReferences(
                                db,
                                table,
                                p0,
                              ).abastecimentosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jornadaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (passesPlataformaRefs)
                        await $_getPrefetchedData<
                          Jornada,
                          $JornadasTable,
                          PassesPlataformaData
                        >(
                          currentTable: table,
                          referencedTable: $$JornadasTableReferences
                              ._passesPlataformaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JornadasTableReferences(
                                db,
                                table,
                                p0,
                              ).passesPlataformaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jornadaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bonusPromocoesRefs)
                        await $_getPrefetchedData<
                          Jornada,
                          $JornadasTable,
                          BonusPromocao
                        >(
                          currentTable: table,
                          referencedTable: $$JornadasTableReferences
                              ._bonusPromocoesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JornadasTableReferences(
                                db,
                                table,
                                p0,
                              ).bonusPromocoesRefs,
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
      PrefetchHooks Function({
        bool usuarioId,
        bool veiculoId,
        bool pausasRefs,
        bool leiturasGanhosRefs,
        bool lancamentosGanhoIndividualRefs,
        bool abastecimentosRefs,
        bool passesPlataformaRefs,
        bool bonusPromocoesRefs,
      })
    >;
typedef $$PausasTableCreateCompanionBuilder =
    PausasCompanion Function({
      Value<int> id,
      required int jornadaId,
      required DateTime inicio,
      Value<DateTime?> fim,
      Value<int?> odometroInicio,
      Value<int?> odometroFim,
      Value<String?> titulo,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
    });
typedef $$PausasTableUpdateCompanionBuilder =
    PausasCompanion Function({
      Value<int> id,
      Value<int> jornadaId,
      Value<DateTime> inicio,
      Value<DateTime?> fim,
      Value<int?> odometroInicio,
      Value<int?> odometroFim,
      Value<String?> titulo,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
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

  static MultiTypedResultKey<$LeiturasGanhosTable, List<LeiturasGanho>>
  _leiturasGanhosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.leiturasGanhos,
    aliasName: 'pausas__id__leituras_ganhos__pausa_id',
  );

  $$LeiturasGanhosTableProcessedTableManager get leiturasGanhosRefs {
    final manager = $$LeiturasGanhosTableTableManager(
      $_db,
      $_db.leiturasGanhos,
    ).filter((f) => f.pausaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_leiturasGanhosRefsTable($_db));
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

  ColumnFilters<int> get odometroInicio => $composableBuilder(
    column: $table.odometroInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odometroFim => $composableBuilder(
    column: $table.odometroFim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
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

  Expression<bool> leiturasGanhosRefs(
    Expression<bool> Function($$LeiturasGanhosTableFilterComposer f) f,
  ) {
    final $$LeiturasGanhosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leiturasGanhos,
      getReferencedColumn: (t) => t.pausaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeiturasGanhosTableFilterComposer(
            $db: $db,
            $table: $db.leiturasGanhos,
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

  ColumnOrderings<int> get odometroInicio => $composableBuilder(
    column: $table.odometroInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odometroFim => $composableBuilder(
    column: $table.odometroFim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
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

  GeneratedColumn<int> get odometroInicio => $composableBuilder(
    column: $table.odometroInicio,
    builder: (column) => column,
  );

  GeneratedColumn<int> get odometroFim => $composableBuilder(
    column: $table.odometroFim,
    builder: (column) => column,
  );

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

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

  Expression<T> leiturasGanhosRefs<T extends Object>(
    Expression<T> Function($$LeiturasGanhosTableAnnotationComposer a) f,
  ) {
    final $$LeiturasGanhosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leiturasGanhos,
      getReferencedColumn: (t) => t.pausaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeiturasGanhosTableAnnotationComposer(
            $db: $db,
            $table: $db.leiturasGanhos,
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
          PrefetchHooks Function({bool jornadaId, bool leiturasGanhosRefs})
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
                Value<int?> odometroInicio = const Value.absent(),
                Value<int?> odometroFim = const Value.absent(),
                Value<String?> titulo = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => PausasCompanion(
                id: id,
                jornadaId: jornadaId,
                inicio: inicio,
                fim: fim,
                odometroInicio: odometroInicio,
                odometroFim: odometroFim,
                titulo: titulo,
                observacao: observacao,
                dataCriacao: dataCriacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int jornadaId,
                required DateTime inicio,
                Value<DateTime?> fim = const Value.absent(),
                Value<int?> odometroInicio = const Value.absent(),
                Value<int?> odometroFim = const Value.absent(),
                Value<String?> titulo = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => PausasCompanion.insert(
                id: id,
                jornadaId: jornadaId,
                inicio: inicio,
                fim: fim,
                odometroInicio: odometroInicio,
                odometroFim: odometroFim,
                titulo: titulo,
                observacao: observacao,
                dataCriacao: dataCriacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PausasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({jornadaId = false, leiturasGanhosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (leiturasGanhosRefs) db.leiturasGanhos,
                  ],
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
                      if (leiturasGanhosRefs)
                        await $_getPrefetchedData<
                          Pausa,
                          $PausasTable,
                          LeiturasGanho
                        >(
                          currentTable: table,
                          referencedTable: $$PausasTableReferences
                              ._leiturasGanhosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PausasTableReferences(
                                db,
                                table,
                                p0,
                              ).leiturasGanhosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pausaId == item.id,
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
      PrefetchHooks Function({bool jornadaId, bool leiturasGanhosRefs})
    >;
typedef $$PlataformasTableCreateCompanionBuilder =
    PlataformasCompanion Function({
      Value<int> id,
      required String nome,
      required TipoRegistroGanhos tipoRegistroGanhos,
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
      Value<TipoRegistroGanhos> tipoRegistroGanhos,
      Value<String?> icone,
      Value<String?> cor,
      Value<bool> ativa,
      Value<int> ordem,
      Value<DateTime> dataCriacao,
    });

final class $$PlataformasTableReferences
    extends BaseReferences<_$AppDatabase, $PlataformasTable, Plataforma> {
  $$PlataformasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $LeiturasGanhoPlataformaTable,
    List<LeiturasGanhoPlataformaData>
  >
  _leiturasGanhoPlataformaRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.leiturasGanhoPlataforma,
        aliasName: 'plataformas__id__leituras_ganho_plataforma__plataforma_id',
      );

  $$LeiturasGanhoPlataformaTableProcessedTableManager
  get leiturasGanhoPlataformaRefs {
    final manager = $$LeiturasGanhoPlataformaTableTableManager(
      $_db,
      $_db.leiturasGanhoPlataforma,
    ).filter((f) => f.plataformaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _leiturasGanhoPlataformaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LancamentosGanhoIndividualTable,
    List<LancamentosGanhoIndividualData>
  >
  _lancamentosGanhoIndividualRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.lancamentosGanhoIndividual,
        aliasName:
            'plataformas__id__lancamentos_ganho_individual__plataforma_id',
      );

  $$LancamentosGanhoIndividualTableProcessedTableManager
  get lancamentosGanhoIndividualRefs {
    final manager = $$LancamentosGanhoIndividualTableTableManager(
      $_db,
      $_db.lancamentosGanhoIndividual,
    ).filter((f) => f.plataformaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _lancamentosGanhoIndividualRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PassesPlataformaTable, List<PassesPlataformaData>>
  _passesPlataformaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.passesPlataforma,
    aliasName: 'plataformas__id__passes_plataforma__plataforma_id',
  );

  $$PassesPlataformaTableProcessedTableManager get passesPlataformaRefs {
    final manager = $$PassesPlataformaTableTableManager(
      $_db,
      $_db.passesPlataforma,
    ).filter((f) => f.plataformaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _passesPlataformaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BonusPromocoesTable, List<BonusPromocao>>
  _bonusPromocoesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bonusPromocoes,
    aliasName: 'plataformas__id__bonus_promocoes__plataforma_id',
  );

  $$BonusPromocoesTableProcessedTableManager get bonusPromocoesRefs {
    final manager = $$BonusPromocoesTableTableManager(
      $_db,
      $_db.bonusPromocoes,
    ).filter((f) => f.plataformaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bonusPromocoesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CustosRecorrentesTable, List<CustoRecorrente>>
  _custosRecorrentesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.custosRecorrentes,
        aliasName: 'plataformas__id__custos_recorrentes__plataforma_id',
      );

  $$CustosRecorrentesTableProcessedTableManager get custosRecorrentesRefs {
    final manager = $$CustosRecorrentesTableTableManager(
      $_db,
      $_db.custosRecorrentes,
    ).filter((f) => f.plataformaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _custosRecorrentesRefsTable($_db),
    );
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

  ColumnWithTypeConverterFilters<TipoRegistroGanhos, TipoRegistroGanhos, String>
  get tipoRegistroGanhos => $composableBuilder(
    column: $table.tipoRegistroGanhos,
    builder: (column) => ColumnWithTypeConverterFilters(column),
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

  Expression<bool> leiturasGanhoPlataformaRefs(
    Expression<bool> Function($$LeiturasGanhoPlataformaTableFilterComposer f) f,
  ) {
    final $$LeiturasGanhoPlataformaTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.leiturasGanhoPlataforma,
          getReferencedColumn: (t) => t.plataformaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LeiturasGanhoPlataformaTableFilterComposer(
                $db: $db,
                $table: $db.leiturasGanhoPlataforma,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> lancamentosGanhoIndividualRefs(
    Expression<bool> Function($$LancamentosGanhoIndividualTableFilterComposer f)
    f,
  ) {
    final $$LancamentosGanhoIndividualTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.lancamentosGanhoIndividual,
          getReferencedColumn: (t) => t.plataformaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LancamentosGanhoIndividualTableFilterComposer(
                $db: $db,
                $table: $db.lancamentosGanhoIndividual,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> passesPlataformaRefs(
    Expression<bool> Function($$PassesPlataformaTableFilterComposer f) f,
  ) {
    final $$PassesPlataformaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.passesPlataforma,
      getReferencedColumn: (t) => t.plataformaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PassesPlataformaTableFilterComposer(
            $db: $db,
            $table: $db.passesPlataforma,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bonusPromocoesRefs(
    Expression<bool> Function($$BonusPromocoesTableFilterComposer f) f,
  ) {
    final $$BonusPromocoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bonusPromocoes,
      getReferencedColumn: (t) => t.plataformaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BonusPromocoesTableFilterComposer(
            $db: $db,
            $table: $db.bonusPromocoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> custosRecorrentesRefs(
    Expression<bool> Function($$CustosRecorrentesTableFilterComposer f) f,
  ) {
    final $$CustosRecorrentesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.custosRecorrentes,
      getReferencedColumn: (t) => t.plataformaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustosRecorrentesTableFilterComposer(
            $db: $db,
            $table: $db.custosRecorrentes,
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

  ColumnOrderings<String> get tipoRegistroGanhos => $composableBuilder(
    column: $table.tipoRegistroGanhos,
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

  GeneratedColumnWithTypeConverter<TipoRegistroGanhos, String>
  get tipoRegistroGanhos => $composableBuilder(
    column: $table.tipoRegistroGanhos,
    builder: (column) => column,
  );

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

  Expression<T> leiturasGanhoPlataformaRefs<T extends Object>(
    Expression<T> Function($$LeiturasGanhoPlataformaTableAnnotationComposer a)
    f,
  ) {
    final $$LeiturasGanhoPlataformaTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.leiturasGanhoPlataforma,
          getReferencedColumn: (t) => t.plataformaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LeiturasGanhoPlataformaTableAnnotationComposer(
                $db: $db,
                $table: $db.leiturasGanhoPlataforma,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> lancamentosGanhoIndividualRefs<T extends Object>(
    Expression<T> Function(
      $$LancamentosGanhoIndividualTableAnnotationComposer a,
    )
    f,
  ) {
    final $$LancamentosGanhoIndividualTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.lancamentosGanhoIndividual,
          getReferencedColumn: (t) => t.plataformaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LancamentosGanhoIndividualTableAnnotationComposer(
                $db: $db,
                $table: $db.lancamentosGanhoIndividual,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> passesPlataformaRefs<T extends Object>(
    Expression<T> Function($$PassesPlataformaTableAnnotationComposer a) f,
  ) {
    final $$PassesPlataformaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.passesPlataforma,
      getReferencedColumn: (t) => t.plataformaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PassesPlataformaTableAnnotationComposer(
            $db: $db,
            $table: $db.passesPlataforma,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bonusPromocoesRefs<T extends Object>(
    Expression<T> Function($$BonusPromocoesTableAnnotationComposer a) f,
  ) {
    final $$BonusPromocoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bonusPromocoes,
      getReferencedColumn: (t) => t.plataformaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BonusPromocoesTableAnnotationComposer(
            $db: $db,
            $table: $db.bonusPromocoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> custosRecorrentesRefs<T extends Object>(
    Expression<T> Function($$CustosRecorrentesTableAnnotationComposer a) f,
  ) {
    final $$CustosRecorrentesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.custosRecorrentes,
          getReferencedColumn: (t) => t.plataformaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CustosRecorrentesTableAnnotationComposer(
                $db: $db,
                $table: $db.custosRecorrentes,
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
          PrefetchHooks Function({
            bool leiturasGanhoPlataformaRefs,
            bool lancamentosGanhoIndividualRefs,
            bool passesPlataformaRefs,
            bool bonusPromocoesRefs,
            bool custosRecorrentesRefs,
          })
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
                Value<TipoRegistroGanhos> tipoRegistroGanhos =
                    const Value.absent(),
                Value<String?> icone = const Value.absent(),
                Value<String?> cor = const Value.absent(),
                Value<bool> ativa = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => PlataformasCompanion(
                id: id,
                nome: nome,
                tipoRegistroGanhos: tipoRegistroGanhos,
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
                required TipoRegistroGanhos tipoRegistroGanhos,
                Value<String?> icone = const Value.absent(),
                Value<String?> cor = const Value.absent(),
                Value<bool> ativa = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => PlataformasCompanion.insert(
                id: id,
                nome: nome,
                tipoRegistroGanhos: tipoRegistroGanhos,
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
          prefetchHooksCallback:
              ({
                leiturasGanhoPlataformaRefs = false,
                lancamentosGanhoIndividualRefs = false,
                passesPlataformaRefs = false,
                bonusPromocoesRefs = false,
                custosRecorrentesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (leiturasGanhoPlataformaRefs) db.leiturasGanhoPlataforma,
                    if (lancamentosGanhoIndividualRefs)
                      db.lancamentosGanhoIndividual,
                    if (passesPlataformaRefs) db.passesPlataforma,
                    if (bonusPromocoesRefs) db.bonusPromocoes,
                    if (custosRecorrentesRefs) db.custosRecorrentes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (leiturasGanhoPlataformaRefs)
                        await $_getPrefetchedData<
                          Plataforma,
                          $PlataformasTable,
                          LeiturasGanhoPlataformaData
                        >(
                          currentTable: table,
                          referencedTable: $$PlataformasTableReferences
                              ._leiturasGanhoPlataformaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlataformasTableReferences(
                                db,
                                table,
                                p0,
                              ).leiturasGanhoPlataformaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.plataformaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (lancamentosGanhoIndividualRefs)
                        await $_getPrefetchedData<
                          Plataforma,
                          $PlataformasTable,
                          LancamentosGanhoIndividualData
                        >(
                          currentTable: table,
                          referencedTable: $$PlataformasTableReferences
                              ._lancamentosGanhoIndividualRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlataformasTableReferences(
                                db,
                                table,
                                p0,
                              ).lancamentosGanhoIndividualRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.plataformaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (passesPlataformaRefs)
                        await $_getPrefetchedData<
                          Plataforma,
                          $PlataformasTable,
                          PassesPlataformaData
                        >(
                          currentTable: table,
                          referencedTable: $$PlataformasTableReferences
                              ._passesPlataformaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlataformasTableReferences(
                                db,
                                table,
                                p0,
                              ).passesPlataformaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.plataformaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bonusPromocoesRefs)
                        await $_getPrefetchedData<
                          Plataforma,
                          $PlataformasTable,
                          BonusPromocao
                        >(
                          currentTable: table,
                          referencedTable: $$PlataformasTableReferences
                              ._bonusPromocoesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlataformasTableReferences(
                                db,
                                table,
                                p0,
                              ).bonusPromocoesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.plataformaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (custosRecorrentesRefs)
                        await $_getPrefetchedData<
                          Plataforma,
                          $PlataformasTable,
                          CustoRecorrente
                        >(
                          currentTable: table,
                          referencedTable: $$PlataformasTableReferences
                              ._custosRecorrentesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlataformasTableReferences(
                                db,
                                table,
                                p0,
                              ).custosRecorrentesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
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
      PrefetchHooks Function({
        bool leiturasGanhoPlataformaRefs,
        bool lancamentosGanhoIndividualRefs,
        bool passesPlataformaRefs,
        bool bonusPromocoesRefs,
        bool custosRecorrentesRefs,
      })
    >;
typedef $$LeiturasGanhosTableCreateCompanionBuilder =
    LeiturasGanhosCompanion Function({
      Value<int> id,
      required int jornadaId,
      Value<int?> pausaId,
      required DateTime dataHora,
      required TipoLeituraGanhos tipo,
      Value<DateTime> dataCriacao,
    });
typedef $$LeiturasGanhosTableUpdateCompanionBuilder =
    LeiturasGanhosCompanion Function({
      Value<int> id,
      Value<int> jornadaId,
      Value<int?> pausaId,
      Value<DateTime> dataHora,
      Value<TipoLeituraGanhos> tipo,
      Value<DateTime> dataCriacao,
    });

final class $$LeiturasGanhosTableReferences
    extends BaseReferences<_$AppDatabase, $LeiturasGanhosTable, LeiturasGanho> {
  $$LeiturasGanhosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JornadasTable _jornadaIdTable(_$AppDatabase db) =>
      db.jornadas.createAlias('leituras_ganhos__jornada_id__jornadas__id');

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

  static $PausasTable _pausaIdTable(_$AppDatabase db) =>
      db.pausas.createAlias('leituras_ganhos__pausa_id__pausas__id');

  $$PausasTableProcessedTableManager? get pausaId {
    final $_column = $_itemColumn<int>('pausa_id');
    if ($_column == null) return null;
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

  static MultiTypedResultKey<
    $LeiturasGanhoPlataformaTable,
    List<LeiturasGanhoPlataformaData>
  >
  _leiturasGanhoPlataformaRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.leiturasGanhoPlataforma,
        aliasName:
            'leituras_ganhos__id__leituras_ganho_plataforma__leitura_ganhos_id',
      );

  $$LeiturasGanhoPlataformaTableProcessedTableManager
  get leiturasGanhoPlataformaRefs {
    final manager = $$LeiturasGanhoPlataformaTableTableManager(
      $_db,
      $_db.leiturasGanhoPlataforma,
    ).filter((f) => f.leituraGanhosId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _leiturasGanhoPlataformaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LeiturasGanhosTableFilterComposer
    extends Composer<_$AppDatabase, $LeiturasGanhosTable> {
  $$LeiturasGanhosTableFilterComposer({
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

  ColumnFilters<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoLeituraGanhos, TipoLeituraGanhos, String>
  get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
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

  Expression<bool> leiturasGanhoPlataformaRefs(
    Expression<bool> Function($$LeiturasGanhoPlataformaTableFilterComposer f) f,
  ) {
    final $$LeiturasGanhoPlataformaTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.leiturasGanhoPlataforma,
          getReferencedColumn: (t) => t.leituraGanhosId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LeiturasGanhoPlataformaTableFilterComposer(
                $db: $db,
                $table: $db.leiturasGanhoPlataforma,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LeiturasGanhosTableOrderingComposer
    extends Composer<_$AppDatabase, $LeiturasGanhosTable> {
  $$LeiturasGanhosTableOrderingComposer({
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

  ColumnOrderings<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
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
}

class $$LeiturasGanhosTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeiturasGanhosTable> {
  $$LeiturasGanhosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataHora =>
      $composableBuilder(column: $table.dataHora, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoLeituraGanhos, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

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

  Expression<T> leiturasGanhoPlataformaRefs<T extends Object>(
    Expression<T> Function($$LeiturasGanhoPlataformaTableAnnotationComposer a)
    f,
  ) {
    final $$LeiturasGanhoPlataformaTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.leiturasGanhoPlataforma,
          getReferencedColumn: (t) => t.leituraGanhosId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LeiturasGanhoPlataformaTableAnnotationComposer(
                $db: $db,
                $table: $db.leiturasGanhoPlataforma,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LeiturasGanhosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeiturasGanhosTable,
          LeiturasGanho,
          $$LeiturasGanhosTableFilterComposer,
          $$LeiturasGanhosTableOrderingComposer,
          $$LeiturasGanhosTableAnnotationComposer,
          $$LeiturasGanhosTableCreateCompanionBuilder,
          $$LeiturasGanhosTableUpdateCompanionBuilder,
          (LeiturasGanho, $$LeiturasGanhosTableReferences),
          LeiturasGanho,
          PrefetchHooks Function({
            bool jornadaId,
            bool pausaId,
            bool leiturasGanhoPlataformaRefs,
          })
        > {
  $$LeiturasGanhosTableTableManager(
    _$AppDatabase db,
    $LeiturasGanhosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeiturasGanhosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeiturasGanhosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeiturasGanhosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> jornadaId = const Value.absent(),
                Value<int?> pausaId = const Value.absent(),
                Value<DateTime> dataHora = const Value.absent(),
                Value<TipoLeituraGanhos> tipo = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => LeiturasGanhosCompanion(
                id: id,
                jornadaId: jornadaId,
                pausaId: pausaId,
                dataHora: dataHora,
                tipo: tipo,
                dataCriacao: dataCriacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int jornadaId,
                Value<int?> pausaId = const Value.absent(),
                required DateTime dataHora,
                required TipoLeituraGanhos tipo,
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => LeiturasGanhosCompanion.insert(
                id: id,
                jornadaId: jornadaId,
                pausaId: pausaId,
                dataHora: dataHora,
                tipo: tipo,
                dataCriacao: dataCriacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LeiturasGanhosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                jornadaId = false,
                pausaId = false,
                leiturasGanhoPlataformaRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (leiturasGanhoPlataformaRefs) db.leiturasGanhoPlataforma,
                  ],
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
                                    referencedTable:
                                        $$LeiturasGanhosTableReferences
                                            ._jornadaIdTable(db),
                                    referencedColumn:
                                        $$LeiturasGanhosTableReferences
                                            ._jornadaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (pausaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.pausaId,
                                    referencedTable:
                                        $$LeiturasGanhosTableReferences
                                            ._pausaIdTable(db),
                                    referencedColumn:
                                        $$LeiturasGanhosTableReferences
                                            ._pausaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (leiturasGanhoPlataformaRefs)
                        await $_getPrefetchedData<
                          LeiturasGanho,
                          $LeiturasGanhosTable,
                          LeiturasGanhoPlataformaData
                        >(
                          currentTable: table,
                          referencedTable: $$LeiturasGanhosTableReferences
                              ._leiturasGanhoPlataformaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LeiturasGanhosTableReferences(
                                db,
                                table,
                                p0,
                              ).leiturasGanhoPlataformaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.leituraGanhosId == item.id,
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

typedef $$LeiturasGanhosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeiturasGanhosTable,
      LeiturasGanho,
      $$LeiturasGanhosTableFilterComposer,
      $$LeiturasGanhosTableOrderingComposer,
      $$LeiturasGanhosTableAnnotationComposer,
      $$LeiturasGanhosTableCreateCompanionBuilder,
      $$LeiturasGanhosTableUpdateCompanionBuilder,
      (LeiturasGanho, $$LeiturasGanhosTableReferences),
      LeiturasGanho,
      PrefetchHooks Function({
        bool jornadaId,
        bool pausaId,
        bool leiturasGanhoPlataformaRefs,
      })
    >;
typedef $$LeiturasGanhoPlataformaTableCreateCompanionBuilder =
    LeiturasGanhoPlataformaCompanion Function({
      Value<int> id,
      required int leituraGanhosId,
      required int plataformaId,
      required int valorAcumuladoCentavos,
      required int quantidadeViagensAcumulada,
    });
typedef $$LeiturasGanhoPlataformaTableUpdateCompanionBuilder =
    LeiturasGanhoPlataformaCompanion Function({
      Value<int> id,
      Value<int> leituraGanhosId,
      Value<int> plataformaId,
      Value<int> valorAcumuladoCentavos,
      Value<int> quantidadeViagensAcumulada,
    });

final class $$LeiturasGanhoPlataformaTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $LeiturasGanhoPlataformaTable,
          LeiturasGanhoPlataformaData
        > {
  $$LeiturasGanhoPlataformaTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LeiturasGanhosTable _leituraGanhosIdTable(_$AppDatabase db) =>
      db.leiturasGanhos.createAlias(
        'leituras_ganho_plataforma__leitura_ganhos_id__leituras_ganhos__id',
      );

  $$LeiturasGanhosTableProcessedTableManager get leituraGanhosId {
    final $_column = $_itemColumn<int>('leitura_ganhos_id')!;

    final manager = $$LeiturasGanhosTableTableManager(
      $_db,
      $_db.leiturasGanhos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_leituraGanhosIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlataformasTable _plataformaIdTable(_$AppDatabase db) => db
      .plataformas
      .createAlias('leituras_ganho_plataforma__plataforma_id__plataformas__id');

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

class $$LeiturasGanhoPlataformaTableFilterComposer
    extends Composer<_$AppDatabase, $LeiturasGanhoPlataformaTable> {
  $$LeiturasGanhoPlataformaTableFilterComposer({
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

  ColumnFilters<int> get valorAcumuladoCentavos => $composableBuilder(
    column: $table.valorAcumuladoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantidadeViagensAcumulada => $composableBuilder(
    column: $table.quantidadeViagensAcumulada,
    builder: (column) => ColumnFilters(column),
  );

  $$LeiturasGanhosTableFilterComposer get leituraGanhosId {
    final $$LeiturasGanhosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leituraGanhosId,
      referencedTable: $db.leiturasGanhos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeiturasGanhosTableFilterComposer(
            $db: $db,
            $table: $db.leiturasGanhos,
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

class $$LeiturasGanhoPlataformaTableOrderingComposer
    extends Composer<_$AppDatabase, $LeiturasGanhoPlataformaTable> {
  $$LeiturasGanhoPlataformaTableOrderingComposer({
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

  ColumnOrderings<int> get valorAcumuladoCentavos => $composableBuilder(
    column: $table.valorAcumuladoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantidadeViagensAcumulada => $composableBuilder(
    column: $table.quantidadeViagensAcumulada,
    builder: (column) => ColumnOrderings(column),
  );

  $$LeiturasGanhosTableOrderingComposer get leituraGanhosId {
    final $$LeiturasGanhosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leituraGanhosId,
      referencedTable: $db.leiturasGanhos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeiturasGanhosTableOrderingComposer(
            $db: $db,
            $table: $db.leiturasGanhos,
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

class $$LeiturasGanhoPlataformaTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeiturasGanhoPlataformaTable> {
  $$LeiturasGanhoPlataformaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get valorAcumuladoCentavos => $composableBuilder(
    column: $table.valorAcumuladoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantidadeViagensAcumulada => $composableBuilder(
    column: $table.quantidadeViagensAcumulada,
    builder: (column) => column,
  );

  $$LeiturasGanhosTableAnnotationComposer get leituraGanhosId {
    final $$LeiturasGanhosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.leituraGanhosId,
      referencedTable: $db.leiturasGanhos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeiturasGanhosTableAnnotationComposer(
            $db: $db,
            $table: $db.leiturasGanhos,
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

class $$LeiturasGanhoPlataformaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeiturasGanhoPlataformaTable,
          LeiturasGanhoPlataformaData,
          $$LeiturasGanhoPlataformaTableFilterComposer,
          $$LeiturasGanhoPlataformaTableOrderingComposer,
          $$LeiturasGanhoPlataformaTableAnnotationComposer,
          $$LeiturasGanhoPlataformaTableCreateCompanionBuilder,
          $$LeiturasGanhoPlataformaTableUpdateCompanionBuilder,
          (
            LeiturasGanhoPlataformaData,
            $$LeiturasGanhoPlataformaTableReferences,
          ),
          LeiturasGanhoPlataformaData,
          PrefetchHooks Function({bool leituraGanhosId, bool plataformaId})
        > {
  $$LeiturasGanhoPlataformaTableTableManager(
    _$AppDatabase db,
    $LeiturasGanhoPlataformaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeiturasGanhoPlataformaTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LeiturasGanhoPlataformaTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LeiturasGanhoPlataformaTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> leituraGanhosId = const Value.absent(),
                Value<int> plataformaId = const Value.absent(),
                Value<int> valorAcumuladoCentavos = const Value.absent(),
                Value<int> quantidadeViagensAcumulada = const Value.absent(),
              }) => LeiturasGanhoPlataformaCompanion(
                id: id,
                leituraGanhosId: leituraGanhosId,
                plataformaId: plataformaId,
                valorAcumuladoCentavos: valorAcumuladoCentavos,
                quantidadeViagensAcumulada: quantidadeViagensAcumulada,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int leituraGanhosId,
                required int plataformaId,
                required int valorAcumuladoCentavos,
                required int quantidadeViagensAcumulada,
              }) => LeiturasGanhoPlataformaCompanion.insert(
                id: id,
                leituraGanhosId: leituraGanhosId,
                plataformaId: plataformaId,
                valorAcumuladoCentavos: valorAcumuladoCentavos,
                quantidadeViagensAcumulada: quantidadeViagensAcumulada,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LeiturasGanhoPlataformaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({leituraGanhosId = false, plataformaId = false}) {
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
                        if (leituraGanhosId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.leituraGanhosId,
                                    referencedTable:
                                        $$LeiturasGanhoPlataformaTableReferences
                                            ._leituraGanhosIdTable(db),
                                    referencedColumn:
                                        $$LeiturasGanhoPlataformaTableReferences
                                            ._leituraGanhosIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (plataformaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.plataformaId,
                                    referencedTable:
                                        $$LeiturasGanhoPlataformaTableReferences
                                            ._plataformaIdTable(db),
                                    referencedColumn:
                                        $$LeiturasGanhoPlataformaTableReferences
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

typedef $$LeiturasGanhoPlataformaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeiturasGanhoPlataformaTable,
      LeiturasGanhoPlataformaData,
      $$LeiturasGanhoPlataformaTableFilterComposer,
      $$LeiturasGanhoPlataformaTableOrderingComposer,
      $$LeiturasGanhoPlataformaTableAnnotationComposer,
      $$LeiturasGanhoPlataformaTableCreateCompanionBuilder,
      $$LeiturasGanhoPlataformaTableUpdateCompanionBuilder,
      (LeiturasGanhoPlataformaData, $$LeiturasGanhoPlataformaTableReferences),
      LeiturasGanhoPlataformaData,
      PrefetchHooks Function({bool leituraGanhosId, bool plataformaId})
    >;
typedef $$LancamentosGanhoIndividualTableCreateCompanionBuilder =
    LancamentosGanhoIndividualCompanion Function({
      Value<int> id,
      required int plataformaId,
      Value<int?> jornadaId,
      required int quantidadeViagens,
      required int valorTotalCentavos,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
    });
typedef $$LancamentosGanhoIndividualTableUpdateCompanionBuilder =
    LancamentosGanhoIndividualCompanion Function({
      Value<int> id,
      Value<int> plataformaId,
      Value<int?> jornadaId,
      Value<int> quantidadeViagens,
      Value<int> valorTotalCentavos,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
    });

final class $$LancamentosGanhoIndividualTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $LancamentosGanhoIndividualTable,
          LancamentosGanhoIndividualData
        > {
  $$LancamentosGanhoIndividualTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlataformasTable _plataformaIdTable(_$AppDatabase db) =>
      db.plataformas.createAlias(
        'lancamentos_ganho_individual__plataforma_id__plataformas__id',
      );

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

  static $JornadasTable _jornadaIdTable(_$AppDatabase db) => db.jornadas
      .createAlias('lancamentos_ganho_individual__jornada_id__jornadas__id');

  $$JornadasTableProcessedTableManager? get jornadaId {
    final $_column = $_itemColumn<int>('jornada_id');
    if ($_column == null) return null;
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
}

class $$LancamentosGanhoIndividualTableFilterComposer
    extends Composer<_$AppDatabase, $LancamentosGanhoIndividualTable> {
  $$LancamentosGanhoIndividualTableFilterComposer({
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

  ColumnFilters<int> get quantidadeViagens => $composableBuilder(
    column: $table.quantidadeViagens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valorTotalCentavos => $composableBuilder(
    column: $table.valorTotalCentavos,
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
}

class $$LancamentosGanhoIndividualTableOrderingComposer
    extends Composer<_$AppDatabase, $LancamentosGanhoIndividualTable> {
  $$LancamentosGanhoIndividualTableOrderingComposer({
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

  ColumnOrderings<int> get quantidadeViagens => $composableBuilder(
    column: $table.quantidadeViagens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorTotalCentavos => $composableBuilder(
    column: $table.valorTotalCentavos,
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

class $$LancamentosGanhoIndividualTableAnnotationComposer
    extends Composer<_$AppDatabase, $LancamentosGanhoIndividualTable> {
  $$LancamentosGanhoIndividualTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantidadeViagens => $composableBuilder(
    column: $table.quantidadeViagens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get valorTotalCentavos => $composableBuilder(
    column: $table.valorTotalCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

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
}

class $$LancamentosGanhoIndividualTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LancamentosGanhoIndividualTable,
          LancamentosGanhoIndividualData,
          $$LancamentosGanhoIndividualTableFilterComposer,
          $$LancamentosGanhoIndividualTableOrderingComposer,
          $$LancamentosGanhoIndividualTableAnnotationComposer,
          $$LancamentosGanhoIndividualTableCreateCompanionBuilder,
          $$LancamentosGanhoIndividualTableUpdateCompanionBuilder,
          (
            LancamentosGanhoIndividualData,
            $$LancamentosGanhoIndividualTableReferences,
          ),
          LancamentosGanhoIndividualData,
          PrefetchHooks Function({bool plataformaId, bool jornadaId})
        > {
  $$LancamentosGanhoIndividualTableTableManager(
    _$AppDatabase db,
    $LancamentosGanhoIndividualTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LancamentosGanhoIndividualTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LancamentosGanhoIndividualTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LancamentosGanhoIndividualTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> plataformaId = const Value.absent(),
                Value<int?> jornadaId = const Value.absent(),
                Value<int> quantidadeViagens = const Value.absent(),
                Value<int> valorTotalCentavos = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => LancamentosGanhoIndividualCompanion(
                id: id,
                plataformaId: plataformaId,
                jornadaId: jornadaId,
                quantidadeViagens: quantidadeViagens,
                valorTotalCentavos: valorTotalCentavos,
                observacao: observacao,
                dataCriacao: dataCriacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int plataformaId,
                Value<int?> jornadaId = const Value.absent(),
                required int quantidadeViagens,
                required int valorTotalCentavos,
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => LancamentosGanhoIndividualCompanion.insert(
                id: id,
                plataformaId: plataformaId,
                jornadaId: jornadaId,
                quantidadeViagens: quantidadeViagens,
                valorTotalCentavos: valorTotalCentavos,
                observacao: observacao,
                dataCriacao: dataCriacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LancamentosGanhoIndividualTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({plataformaId = false, jornadaId = false}) {
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
                    if (plataformaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.plataformaId,
                                referencedTable:
                                    $$LancamentosGanhoIndividualTableReferences
                                        ._plataformaIdTable(db),
                                referencedColumn:
                                    $$LancamentosGanhoIndividualTableReferences
                                        ._plataformaIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (jornadaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.jornadaId,
                                referencedTable:
                                    $$LancamentosGanhoIndividualTableReferences
                                        ._jornadaIdTable(db),
                                referencedColumn:
                                    $$LancamentosGanhoIndividualTableReferences
                                        ._jornadaIdTable(db)
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

typedef $$LancamentosGanhoIndividualTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LancamentosGanhoIndividualTable,
      LancamentosGanhoIndividualData,
      $$LancamentosGanhoIndividualTableFilterComposer,
      $$LancamentosGanhoIndividualTableOrderingComposer,
      $$LancamentosGanhoIndividualTableAnnotationComposer,
      $$LancamentosGanhoIndividualTableCreateCompanionBuilder,
      $$LancamentosGanhoIndividualTableUpdateCompanionBuilder,
      (
        LancamentosGanhoIndividualData,
        $$LancamentosGanhoIndividualTableReferences,
      ),
      LancamentosGanhoIndividualData,
      PrefetchHooks Function({bool plataformaId, bool jornadaId})
    >;
typedef $$AbastecimentosTableCreateCompanionBuilder =
    AbastecimentosCompanion Function({
      Value<int> id,
      required int veiculoId,
      Value<int?> jornadaId,
      required DateTime dataHora,
      required int odometro,
      required TipoCombustivel tipoCombustivel,
      required int volumeMililitros,
      required int valorTotalPagoCentavos,
      Value<int?> precoBombaMilesimosRealPorLitro,
      Value<bool> tanqueCheio,
      Value<String?> cidade,
      Value<String?> nomePosto,
      Value<String?> bandeiraPosto,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
    });
typedef $$AbastecimentosTableUpdateCompanionBuilder =
    AbastecimentosCompanion Function({
      Value<int> id,
      Value<int> veiculoId,
      Value<int?> jornadaId,
      Value<DateTime> dataHora,
      Value<int> odometro,
      Value<TipoCombustivel> tipoCombustivel,
      Value<int> volumeMililitros,
      Value<int> valorTotalPagoCentavos,
      Value<int?> precoBombaMilesimosRealPorLitro,
      Value<bool> tanqueCheio,
      Value<String?> cidade,
      Value<String?> nomePosto,
      Value<String?> bandeiraPosto,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
    });

final class $$AbastecimentosTableReferences
    extends BaseReferences<_$AppDatabase, $AbastecimentosTable, Abastecimento> {
  $$AbastecimentosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VeiculosTable _veiculoIdTable(_$AppDatabase db) =>
      db.veiculos.createAlias('abastecimentos__veiculo_id__veiculos__id');

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

  static $JornadasTable _jornadaIdTable(_$AppDatabase db) =>
      db.jornadas.createAlias('abastecimentos__jornada_id__jornadas__id');

  $$JornadasTableProcessedTableManager? get jornadaId {
    final $_column = $_itemColumn<int>('jornada_id');
    if ($_column == null) return null;
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
}

class $$AbastecimentosTableFilterComposer
    extends Composer<_$AppDatabase, $AbastecimentosTable> {
  $$AbastecimentosTableFilterComposer({
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

  ColumnFilters<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odometro => $composableBuilder(
    column: $table.odometro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoCombustivel, TipoCombustivel, String>
  get tipoCombustivel => $composableBuilder(
    column: $table.tipoCombustivel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get volumeMililitros => $composableBuilder(
    column: $table.volumeMililitros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valorTotalPagoCentavos => $composableBuilder(
    column: $table.valorTotalPagoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get precoBombaMilesimosRealPorLitro => $composableBuilder(
    column: $table.precoBombaMilesimosRealPorLitro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get tanqueCheio => $composableBuilder(
    column: $table.tanqueCheio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cidade => $composableBuilder(
    column: $table.cidade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomePosto => $composableBuilder(
    column: $table.nomePosto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bandeiraPosto => $composableBuilder(
    column: $table.bandeiraPosto,
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
}

class $$AbastecimentosTableOrderingComposer
    extends Composer<_$AppDatabase, $AbastecimentosTable> {
  $$AbastecimentosTableOrderingComposer({
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

  ColumnOrderings<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odometro => $composableBuilder(
    column: $table.odometro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoCombustivel => $composableBuilder(
    column: $table.tipoCombustivel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get volumeMililitros => $composableBuilder(
    column: $table.volumeMililitros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorTotalPagoCentavos => $composableBuilder(
    column: $table.valorTotalPagoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get precoBombaMilesimosRealPorLitro =>
      $composableBuilder(
        column: $table.precoBombaMilesimosRealPorLitro,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<bool> get tanqueCheio => $composableBuilder(
    column: $table.tanqueCheio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cidade => $composableBuilder(
    column: $table.cidade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomePosto => $composableBuilder(
    column: $table.nomePosto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bandeiraPosto => $composableBuilder(
    column: $table.bandeiraPosto,
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

class $$AbastecimentosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AbastecimentosTable> {
  $$AbastecimentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataHora =>
      $composableBuilder(column: $table.dataHora, builder: (column) => column);

  GeneratedColumn<int> get odometro =>
      $composableBuilder(column: $table.odometro, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoCombustivel, String>
  get tipoCombustivel => $composableBuilder(
    column: $table.tipoCombustivel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get volumeMililitros => $composableBuilder(
    column: $table.volumeMililitros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get valorTotalPagoCentavos => $composableBuilder(
    column: $table.valorTotalPagoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get precoBombaMilesimosRealPorLitro =>
      $composableBuilder(
        column: $table.precoBombaMilesimosRealPorLitro,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get tanqueCheio => $composableBuilder(
    column: $table.tanqueCheio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cidade =>
      $composableBuilder(column: $table.cidade, builder: (column) => column);

  GeneratedColumn<String> get nomePosto =>
      $composableBuilder(column: $table.nomePosto, builder: (column) => column);

  GeneratedColumn<String> get bandeiraPosto => $composableBuilder(
    column: $table.bandeiraPosto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

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
}

class $$AbastecimentosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AbastecimentosTable,
          Abastecimento,
          $$AbastecimentosTableFilterComposer,
          $$AbastecimentosTableOrderingComposer,
          $$AbastecimentosTableAnnotationComposer,
          $$AbastecimentosTableCreateCompanionBuilder,
          $$AbastecimentosTableUpdateCompanionBuilder,
          (Abastecimento, $$AbastecimentosTableReferences),
          Abastecimento,
          PrefetchHooks Function({bool veiculoId, bool jornadaId})
        > {
  $$AbastecimentosTableTableManager(
    _$AppDatabase db,
    $AbastecimentosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AbastecimentosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AbastecimentosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AbastecimentosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> veiculoId = const Value.absent(),
                Value<int?> jornadaId = const Value.absent(),
                Value<DateTime> dataHora = const Value.absent(),
                Value<int> odometro = const Value.absent(),
                Value<TipoCombustivel> tipoCombustivel = const Value.absent(),
                Value<int> volumeMililitros = const Value.absent(),
                Value<int> valorTotalPagoCentavos = const Value.absent(),
                Value<int?> precoBombaMilesimosRealPorLitro =
                    const Value.absent(),
                Value<bool> tanqueCheio = const Value.absent(),
                Value<String?> cidade = const Value.absent(),
                Value<String?> nomePosto = const Value.absent(),
                Value<String?> bandeiraPosto = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => AbastecimentosCompanion(
                id: id,
                veiculoId: veiculoId,
                jornadaId: jornadaId,
                dataHora: dataHora,
                odometro: odometro,
                tipoCombustivel: tipoCombustivel,
                volumeMililitros: volumeMililitros,
                valorTotalPagoCentavos: valorTotalPagoCentavos,
                precoBombaMilesimosRealPorLitro:
                    precoBombaMilesimosRealPorLitro,
                tanqueCheio: tanqueCheio,
                cidade: cidade,
                nomePosto: nomePosto,
                bandeiraPosto: bandeiraPosto,
                observacao: observacao,
                dataCriacao: dataCriacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int veiculoId,
                Value<int?> jornadaId = const Value.absent(),
                required DateTime dataHora,
                required int odometro,
                required TipoCombustivel tipoCombustivel,
                required int volumeMililitros,
                required int valorTotalPagoCentavos,
                Value<int?> precoBombaMilesimosRealPorLitro =
                    const Value.absent(),
                Value<bool> tanqueCheio = const Value.absent(),
                Value<String?> cidade = const Value.absent(),
                Value<String?> nomePosto = const Value.absent(),
                Value<String?> bandeiraPosto = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => AbastecimentosCompanion.insert(
                id: id,
                veiculoId: veiculoId,
                jornadaId: jornadaId,
                dataHora: dataHora,
                odometro: odometro,
                tipoCombustivel: tipoCombustivel,
                volumeMililitros: volumeMililitros,
                valorTotalPagoCentavos: valorTotalPagoCentavos,
                precoBombaMilesimosRealPorLitro:
                    precoBombaMilesimosRealPorLitro,
                tanqueCheio: tanqueCheio,
                cidade: cidade,
                nomePosto: nomePosto,
                bandeiraPosto: bandeiraPosto,
                observacao: observacao,
                dataCriacao: dataCriacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AbastecimentosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({veiculoId = false, jornadaId = false}) {
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
                    if (veiculoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.veiculoId,
                                referencedTable: $$AbastecimentosTableReferences
                                    ._veiculoIdTable(db),
                                referencedColumn:
                                    $$AbastecimentosTableReferences
                                        ._veiculoIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (jornadaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.jornadaId,
                                referencedTable: $$AbastecimentosTableReferences
                                    ._jornadaIdTable(db),
                                referencedColumn:
                                    $$AbastecimentosTableReferences
                                        ._jornadaIdTable(db)
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

typedef $$AbastecimentosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AbastecimentosTable,
      Abastecimento,
      $$AbastecimentosTableFilterComposer,
      $$AbastecimentosTableOrderingComposer,
      $$AbastecimentosTableAnnotationComposer,
      $$AbastecimentosTableCreateCompanionBuilder,
      $$AbastecimentosTableUpdateCompanionBuilder,
      (Abastecimento, $$AbastecimentosTableReferences),
      Abastecimento,
      PrefetchHooks Function({bool veiculoId, bool jornadaId})
    >;
typedef $$PassesPlataformaTableCreateCompanionBuilder =
    PassesPlataformaCompanion Function({
      Value<int> id,
      required int plataformaId,
      Value<int?> jornadaId,
      required DateTime dataHora,
      required int valorPagoCentavos,
      Value<String?> modalidade,
      Value<DateTime?> validadeAte,
      Value<int?> limiteFaturamentoCentavos,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
    });
typedef $$PassesPlataformaTableUpdateCompanionBuilder =
    PassesPlataformaCompanion Function({
      Value<int> id,
      Value<int> plataformaId,
      Value<int?> jornadaId,
      Value<DateTime> dataHora,
      Value<int> valorPagoCentavos,
      Value<String?> modalidade,
      Value<DateTime?> validadeAte,
      Value<int?> limiteFaturamentoCentavos,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
    });

final class $$PassesPlataformaTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PassesPlataformaTable,
          PassesPlataformaData
        > {
  $$PassesPlataformaTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlataformasTable _plataformaIdTable(_$AppDatabase db) => db
      .plataformas
      .createAlias('passes_plataforma__plataforma_id__plataformas__id');

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

  static $JornadasTable _jornadaIdTable(_$AppDatabase db) =>
      db.jornadas.createAlias('passes_plataforma__jornada_id__jornadas__id');

  $$JornadasTableProcessedTableManager? get jornadaId {
    final $_column = $_itemColumn<int>('jornada_id');
    if ($_column == null) return null;
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
}

class $$PassesPlataformaTableFilterComposer
    extends Composer<_$AppDatabase, $PassesPlataformaTable> {
  $$PassesPlataformaTableFilterComposer({
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

  ColumnFilters<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valorPagoCentavos => $composableBuilder(
    column: $table.valorPagoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modalidade => $composableBuilder(
    column: $table.modalidade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validadeAte => $composableBuilder(
    column: $table.validadeAte,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get limiteFaturamentoCentavos => $composableBuilder(
    column: $table.limiteFaturamentoCentavos,
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
}

class $$PassesPlataformaTableOrderingComposer
    extends Composer<_$AppDatabase, $PassesPlataformaTable> {
  $$PassesPlataformaTableOrderingComposer({
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

  ColumnOrderings<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorPagoCentavos => $composableBuilder(
    column: $table.valorPagoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modalidade => $composableBuilder(
    column: $table.modalidade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validadeAte => $composableBuilder(
    column: $table.validadeAte,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get limiteFaturamentoCentavos => $composableBuilder(
    column: $table.limiteFaturamentoCentavos,
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

class $$PassesPlataformaTableAnnotationComposer
    extends Composer<_$AppDatabase, $PassesPlataformaTable> {
  $$PassesPlataformaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataHora =>
      $composableBuilder(column: $table.dataHora, builder: (column) => column);

  GeneratedColumn<int> get valorPagoCentavos => $composableBuilder(
    column: $table.valorPagoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modalidade => $composableBuilder(
    column: $table.modalidade,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get validadeAte => $composableBuilder(
    column: $table.validadeAte,
    builder: (column) => column,
  );

  GeneratedColumn<int> get limiteFaturamentoCentavos => $composableBuilder(
    column: $table.limiteFaturamentoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

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
}

class $$PassesPlataformaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PassesPlataformaTable,
          PassesPlataformaData,
          $$PassesPlataformaTableFilterComposer,
          $$PassesPlataformaTableOrderingComposer,
          $$PassesPlataformaTableAnnotationComposer,
          $$PassesPlataformaTableCreateCompanionBuilder,
          $$PassesPlataformaTableUpdateCompanionBuilder,
          (PassesPlataformaData, $$PassesPlataformaTableReferences),
          PassesPlataformaData,
          PrefetchHooks Function({bool plataformaId, bool jornadaId})
        > {
  $$PassesPlataformaTableTableManager(
    _$AppDatabase db,
    $PassesPlataformaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PassesPlataformaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PassesPlataformaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PassesPlataformaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> plataformaId = const Value.absent(),
                Value<int?> jornadaId = const Value.absent(),
                Value<DateTime> dataHora = const Value.absent(),
                Value<int> valorPagoCentavos = const Value.absent(),
                Value<String?> modalidade = const Value.absent(),
                Value<DateTime?> validadeAte = const Value.absent(),
                Value<int?> limiteFaturamentoCentavos = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => PassesPlataformaCompanion(
                id: id,
                plataformaId: plataformaId,
                jornadaId: jornadaId,
                dataHora: dataHora,
                valorPagoCentavos: valorPagoCentavos,
                modalidade: modalidade,
                validadeAte: validadeAte,
                limiteFaturamentoCentavos: limiteFaturamentoCentavos,
                observacao: observacao,
                dataCriacao: dataCriacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int plataformaId,
                Value<int?> jornadaId = const Value.absent(),
                required DateTime dataHora,
                required int valorPagoCentavos,
                Value<String?> modalidade = const Value.absent(),
                Value<DateTime?> validadeAte = const Value.absent(),
                Value<int?> limiteFaturamentoCentavos = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => PassesPlataformaCompanion.insert(
                id: id,
                plataformaId: plataformaId,
                jornadaId: jornadaId,
                dataHora: dataHora,
                valorPagoCentavos: valorPagoCentavos,
                modalidade: modalidade,
                validadeAte: validadeAte,
                limiteFaturamentoCentavos: limiteFaturamentoCentavos,
                observacao: observacao,
                dataCriacao: dataCriacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PassesPlataformaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({plataformaId = false, jornadaId = false}) {
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
                    if (plataformaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.plataformaId,
                                referencedTable:
                                    $$PassesPlataformaTableReferences
                                        ._plataformaIdTable(db),
                                referencedColumn:
                                    $$PassesPlataformaTableReferences
                                        ._plataformaIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (jornadaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.jornadaId,
                                referencedTable:
                                    $$PassesPlataformaTableReferences
                                        ._jornadaIdTable(db),
                                referencedColumn:
                                    $$PassesPlataformaTableReferences
                                        ._jornadaIdTable(db)
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

typedef $$PassesPlataformaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PassesPlataformaTable,
      PassesPlataformaData,
      $$PassesPlataformaTableFilterComposer,
      $$PassesPlataformaTableOrderingComposer,
      $$PassesPlataformaTableAnnotationComposer,
      $$PassesPlataformaTableCreateCompanionBuilder,
      $$PassesPlataformaTableUpdateCompanionBuilder,
      (PassesPlataformaData, $$PassesPlataformaTableReferences),
      PassesPlataformaData,
      PrefetchHooks Function({bool plataformaId, bool jornadaId})
    >;
typedef $$BonusPromocoesTableCreateCompanionBuilder =
    BonusPromocoesCompanion Function({
      Value<int> id,
      required int plataformaId,
      Value<int?> jornadaId,
      required DateTime dataHora,
      required int valorCentavos,
      required TipoBonusPromocao tipo,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
    });
typedef $$BonusPromocoesTableUpdateCompanionBuilder =
    BonusPromocoesCompanion Function({
      Value<int> id,
      Value<int> plataformaId,
      Value<int?> jornadaId,
      Value<DateTime> dataHora,
      Value<int> valorCentavos,
      Value<TipoBonusPromocao> tipo,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
    });

final class $$BonusPromocoesTableReferences
    extends BaseReferences<_$AppDatabase, $BonusPromocoesTable, BonusPromocao> {
  $$BonusPromocoesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlataformasTable _plataformaIdTable(_$AppDatabase db) => db
      .plataformas
      .createAlias('bonus_promocoes__plataforma_id__plataformas__id');

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

  static $JornadasTable _jornadaIdTable(_$AppDatabase db) =>
      db.jornadas.createAlias('bonus_promocoes__jornada_id__jornadas__id');

  $$JornadasTableProcessedTableManager? get jornadaId {
    final $_column = $_itemColumn<int>('jornada_id');
    if ($_column == null) return null;
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
}

class $$BonusPromocoesTableFilterComposer
    extends Composer<_$AppDatabase, $BonusPromocoesTable> {
  $$BonusPromocoesTableFilterComposer({
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

  ColumnFilters<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoBonusPromocao, TipoBonusPromocao, String>
  get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

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
}

class $$BonusPromocoesTableOrderingComposer
    extends Composer<_$AppDatabase, $BonusPromocoesTable> {
  $$BonusPromocoesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
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

class $$BonusPromocoesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BonusPromocoesTable> {
  $$BonusPromocoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataHora =>
      $composableBuilder(column: $table.dataHora, builder: (column) => column);

  GeneratedColumn<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TipoBonusPromocao, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

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
}

class $$BonusPromocoesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BonusPromocoesTable,
          BonusPromocao,
          $$BonusPromocoesTableFilterComposer,
          $$BonusPromocoesTableOrderingComposer,
          $$BonusPromocoesTableAnnotationComposer,
          $$BonusPromocoesTableCreateCompanionBuilder,
          $$BonusPromocoesTableUpdateCompanionBuilder,
          (BonusPromocao, $$BonusPromocoesTableReferences),
          BonusPromocao,
          PrefetchHooks Function({bool plataformaId, bool jornadaId})
        > {
  $$BonusPromocoesTableTableManager(
    _$AppDatabase db,
    $BonusPromocoesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BonusPromocoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BonusPromocoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BonusPromocoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> plataformaId = const Value.absent(),
                Value<int?> jornadaId = const Value.absent(),
                Value<DateTime> dataHora = const Value.absent(),
                Value<int> valorCentavos = const Value.absent(),
                Value<TipoBonusPromocao> tipo = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => BonusPromocoesCompanion(
                id: id,
                plataformaId: plataformaId,
                jornadaId: jornadaId,
                dataHora: dataHora,
                valorCentavos: valorCentavos,
                tipo: tipo,
                observacao: observacao,
                dataCriacao: dataCriacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int plataformaId,
                Value<int?> jornadaId = const Value.absent(),
                required DateTime dataHora,
                required int valorCentavos,
                required TipoBonusPromocao tipo,
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => BonusPromocoesCompanion.insert(
                id: id,
                plataformaId: plataformaId,
                jornadaId: jornadaId,
                dataHora: dataHora,
                valorCentavos: valorCentavos,
                tipo: tipo,
                observacao: observacao,
                dataCriacao: dataCriacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BonusPromocoesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({plataformaId = false, jornadaId = false}) {
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
                    if (plataformaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.plataformaId,
                                referencedTable: $$BonusPromocoesTableReferences
                                    ._plataformaIdTable(db),
                                referencedColumn:
                                    $$BonusPromocoesTableReferences
                                        ._plataformaIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (jornadaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.jornadaId,
                                referencedTable: $$BonusPromocoesTableReferences
                                    ._jornadaIdTable(db),
                                referencedColumn:
                                    $$BonusPromocoesTableReferences
                                        ._jornadaIdTable(db)
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

typedef $$BonusPromocoesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BonusPromocoesTable,
      BonusPromocao,
      $$BonusPromocoesTableFilterComposer,
      $$BonusPromocoesTableOrderingComposer,
      $$BonusPromocoesTableAnnotationComposer,
      $$BonusPromocoesTableCreateCompanionBuilder,
      $$BonusPromocoesTableUpdateCompanionBuilder,
      (BonusPromocao, $$BonusPromocoesTableReferences),
      BonusPromocao,
      PrefetchHooks Function({bool plataformaId, bool jornadaId})
    >;
typedef $$ManutencoesTableCreateCompanionBuilder =
    ManutencoesCompanion Function({
      Value<int> id,
      required int veiculoId,
      required DateTime dataHora,
      required int odometro,
      Value<String?> oficina,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
      Value<DateTime?> dataAtualizacao,
    });
typedef $$ManutencoesTableUpdateCompanionBuilder =
    ManutencoesCompanion Function({
      Value<int> id,
      Value<int> veiculoId,
      Value<DateTime> dataHora,
      Value<int> odometro,
      Value<String?> oficina,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
      Value<DateTime?> dataAtualizacao,
    });

final class $$ManutencoesTableReferences
    extends BaseReferences<_$AppDatabase, $ManutencoesTable, Manutencao> {
  $$ManutencoesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VeiculosTable _veiculoIdTable(_$AppDatabase db) =>
      db.veiculos.createAlias('manutencoes__veiculo_id__veiculos__id');

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

  static MultiTypedResultKey<$ItensManutencaoTable, List<ItemManutencao>>
  _itensManutencaoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itensManutencao,
    aliasName: 'manutencoes__id__itens_manutencao__manutencao_id',
  );

  $$ItensManutencaoTableProcessedTableManager get itensManutencaoRefs {
    final manager = $$ItensManutencaoTableTableManager(
      $_db,
      $_db.itensManutencao,
    ).filter((f) => f.manutencaoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _itensManutencaoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ManutencoesTableFilterComposer
    extends Composer<_$AppDatabase, $ManutencoesTable> {
  $$ManutencoesTableFilterComposer({
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

  ColumnFilters<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odometro => $composableBuilder(
    column: $table.odometro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oficina => $composableBuilder(
    column: $table.oficina,
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

  ColumnFilters<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnFilters(column),
  );

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

  Expression<bool> itensManutencaoRefs(
    Expression<bool> Function($$ItensManutencaoTableFilterComposer f) f,
  ) {
    final $$ItensManutencaoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itensManutencao,
      getReferencedColumn: (t) => t.manutencaoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensManutencaoTableFilterComposer(
            $db: $db,
            $table: $db.itensManutencao,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ManutencoesTableOrderingComposer
    extends Composer<_$AppDatabase, $ManutencoesTable> {
  $$ManutencoesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odometro => $composableBuilder(
    column: $table.odometro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oficina => $composableBuilder(
    column: $table.oficina,
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

  ColumnOrderings<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnOrderings(column),
  );

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

class $$ManutencoesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ManutencoesTable> {
  $$ManutencoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataHora =>
      $composableBuilder(column: $table.dataHora, builder: (column) => column);

  GeneratedColumn<int> get odometro =>
      $composableBuilder(column: $table.odometro, builder: (column) => column);

  GeneratedColumn<String> get oficina =>
      $composableBuilder(column: $table.oficina, builder: (column) => column);

  GeneratedColumn<String> get observacao => $composableBuilder(
    column: $table.observacao,
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

  Expression<T> itensManutencaoRefs<T extends Object>(
    Expression<T> Function($$ItensManutencaoTableAnnotationComposer a) f,
  ) {
    final $$ItensManutencaoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itensManutencao,
      getReferencedColumn: (t) => t.manutencaoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensManutencaoTableAnnotationComposer(
            $db: $db,
            $table: $db.itensManutencao,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ManutencoesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ManutencoesTable,
          Manutencao,
          $$ManutencoesTableFilterComposer,
          $$ManutencoesTableOrderingComposer,
          $$ManutencoesTableAnnotationComposer,
          $$ManutencoesTableCreateCompanionBuilder,
          $$ManutencoesTableUpdateCompanionBuilder,
          (Manutencao, $$ManutencoesTableReferences),
          Manutencao,
          PrefetchHooks Function({bool veiculoId, bool itensManutencaoRefs})
        > {
  $$ManutencoesTableTableManager(_$AppDatabase db, $ManutencoesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ManutencoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ManutencoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ManutencoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> veiculoId = const Value.absent(),
                Value<DateTime> dataHora = const Value.absent(),
                Value<int> odometro = const Value.absent(),
                Value<String?> oficina = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime?> dataAtualizacao = const Value.absent(),
              }) => ManutencoesCompanion(
                id: id,
                veiculoId: veiculoId,
                dataHora: dataHora,
                odometro: odometro,
                oficina: oficina,
                observacao: observacao,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int veiculoId,
                required DateTime dataHora,
                required int odometro,
                Value<String?> oficina = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime?> dataAtualizacao = const Value.absent(),
              }) => ManutencoesCompanion.insert(
                id: id,
                veiculoId: veiculoId,
                dataHora: dataHora,
                odometro: odometro,
                oficina: oficina,
                observacao: observacao,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ManutencoesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({veiculoId = false, itensManutencaoRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (itensManutencaoRefs) db.itensManutencao,
                  ],
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
                        if (veiculoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.veiculoId,
                                    referencedTable:
                                        $$ManutencoesTableReferences
                                            ._veiculoIdTable(db),
                                    referencedColumn:
                                        $$ManutencoesTableReferences
                                            ._veiculoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (itensManutencaoRefs)
                        await $_getPrefetchedData<
                          Manutencao,
                          $ManutencoesTable,
                          ItemManutencao
                        >(
                          currentTable: table,
                          referencedTable: $$ManutencoesTableReferences
                              ._itensManutencaoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ManutencoesTableReferences(
                                db,
                                table,
                                p0,
                              ).itensManutencaoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.manutencaoId == item.id,
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

typedef $$ManutencoesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ManutencoesTable,
      Manutencao,
      $$ManutencoesTableFilterComposer,
      $$ManutencoesTableOrderingComposer,
      $$ManutencoesTableAnnotationComposer,
      $$ManutencoesTableCreateCompanionBuilder,
      $$ManutencoesTableUpdateCompanionBuilder,
      (Manutencao, $$ManutencoesTableReferences),
      Manutencao,
      PrefetchHooks Function({bool veiculoId, bool itensManutencaoRefs})
    >;
typedef $$ItensManutencaoTableCreateCompanionBuilder =
    ItensManutencaoCompanion Function({
      Value<int> id,
      required int manutencaoId,
      required String descricao,
      Value<int?> valorCentavos,
      Value<int?> intervaloKm,
      Value<DateTime?> vencimentoEm,
      Value<DateTime> dataCriacao,
      Value<DateTime?> dataAtualizacao,
    });
typedef $$ItensManutencaoTableUpdateCompanionBuilder =
    ItensManutencaoCompanion Function({
      Value<int> id,
      Value<int> manutencaoId,
      Value<String> descricao,
      Value<int?> valorCentavos,
      Value<int?> intervaloKm,
      Value<DateTime?> vencimentoEm,
      Value<DateTime> dataCriacao,
      Value<DateTime?> dataAtualizacao,
    });

final class $$ItensManutencaoTableReferences
    extends
        BaseReferences<_$AppDatabase, $ItensManutencaoTable, ItemManutencao> {
  $$ItensManutencaoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ManutencoesTable _manutencaoIdTable(_$AppDatabase db) => db
      .manutencoes
      .createAlias('itens_manutencao__manutencao_id__manutencoes__id');

  $$ManutencoesTableProcessedTableManager get manutencaoId {
    final $_column = $_itemColumn<int>('manutencao_id')!;

    final manager = $$ManutencoesTableTableManager(
      $_db,
      $_db.manutencoes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_manutencaoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItensManutencaoTableFilterComposer
    extends Composer<_$AppDatabase, $ItensManutencaoTable> {
  $$ItensManutencaoTableFilterComposer({
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

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervaloKm => $composableBuilder(
    column: $table.intervaloKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get vencimentoEm => $composableBuilder(
    column: $table.vencimentoEm,
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

  $$ManutencoesTableFilterComposer get manutencaoId {
    final $$ManutencoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.manutencaoId,
      referencedTable: $db.manutencoes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ManutencoesTableFilterComposer(
            $db: $db,
            $table: $db.manutencoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItensManutencaoTableOrderingComposer
    extends Composer<_$AppDatabase, $ItensManutencaoTable> {
  $$ItensManutencaoTableOrderingComposer({
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

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervaloKm => $composableBuilder(
    column: $table.intervaloKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get vencimentoEm => $composableBuilder(
    column: $table.vencimentoEm,
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

  $$ManutencoesTableOrderingComposer get manutencaoId {
    final $$ManutencoesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.manutencaoId,
      referencedTable: $db.manutencoes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ManutencoesTableOrderingComposer(
            $db: $db,
            $table: $db.manutencoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItensManutencaoTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItensManutencaoTable> {
  $$ItensManutencaoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervaloKm => $composableBuilder(
    column: $table.intervaloKm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get vencimentoEm => $composableBuilder(
    column: $table.vencimentoEm,
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

  $$ManutencoesTableAnnotationComposer get manutencaoId {
    final $$ManutencoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.manutencaoId,
      referencedTable: $db.manutencoes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ManutencoesTableAnnotationComposer(
            $db: $db,
            $table: $db.manutencoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItensManutencaoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItensManutencaoTable,
          ItemManutencao,
          $$ItensManutencaoTableFilterComposer,
          $$ItensManutencaoTableOrderingComposer,
          $$ItensManutencaoTableAnnotationComposer,
          $$ItensManutencaoTableCreateCompanionBuilder,
          $$ItensManutencaoTableUpdateCompanionBuilder,
          (ItemManutencao, $$ItensManutencaoTableReferences),
          ItemManutencao,
          PrefetchHooks Function({bool manutencaoId})
        > {
  $$ItensManutencaoTableTableManager(
    _$AppDatabase db,
    $ItensManutencaoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItensManutencaoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItensManutencaoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItensManutencaoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> manutencaoId = const Value.absent(),
                Value<String> descricao = const Value.absent(),
                Value<int?> valorCentavos = const Value.absent(),
                Value<int?> intervaloKm = const Value.absent(),
                Value<DateTime?> vencimentoEm = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime?> dataAtualizacao = const Value.absent(),
              }) => ItensManutencaoCompanion(
                id: id,
                manutencaoId: manutencaoId,
                descricao: descricao,
                valorCentavos: valorCentavos,
                intervaloKm: intervaloKm,
                vencimentoEm: vencimentoEm,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int manutencaoId,
                required String descricao,
                Value<int?> valorCentavos = const Value.absent(),
                Value<int?> intervaloKm = const Value.absent(),
                Value<DateTime?> vencimentoEm = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime?> dataAtualizacao = const Value.absent(),
              }) => ItensManutencaoCompanion.insert(
                id: id,
                manutencaoId: manutencaoId,
                descricao: descricao,
                valorCentavos: valorCentavos,
                intervaloKm: intervaloKm,
                vencimentoEm: vencimentoEm,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ItensManutencaoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({manutencaoId = false}) {
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
                    if (manutencaoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.manutencaoId,
                                referencedTable:
                                    $$ItensManutencaoTableReferences
                                        ._manutencaoIdTable(db),
                                referencedColumn:
                                    $$ItensManutencaoTableReferences
                                        ._manutencaoIdTable(db)
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

typedef $$ItensManutencaoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItensManutencaoTable,
      ItemManutencao,
      $$ItensManutencaoTableFilterComposer,
      $$ItensManutencaoTableOrderingComposer,
      $$ItensManutencaoTableAnnotationComposer,
      $$ItensManutencaoTableCreateCompanionBuilder,
      $$ItensManutencaoTableUpdateCompanionBuilder,
      (ItemManutencao, $$ItensManutencaoTableReferences),
      ItemManutencao,
      PrefetchHooks Function({bool manutencaoId})
    >;
typedef $$DespesasVeiculoTableCreateCompanionBuilder =
    DespesasVeiculoCompanion Function({
      Value<int> id,
      required int veiculoId,
      required TipoDespesaVeiculo tipo,
      required String descricao,
      required int valorCentavos,
      required DateTime dataHora,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
      Value<DateTime?> dataAtualizacao,
    });
typedef $$DespesasVeiculoTableUpdateCompanionBuilder =
    DespesasVeiculoCompanion Function({
      Value<int> id,
      Value<int> veiculoId,
      Value<TipoDespesaVeiculo> tipo,
      Value<String> descricao,
      Value<int> valorCentavos,
      Value<DateTime> dataHora,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
      Value<DateTime?> dataAtualizacao,
    });

final class $$DespesasVeiculoTableReferences
    extends
        BaseReferences<_$AppDatabase, $DespesasVeiculoTable, DespesaVeiculo> {
  $$DespesasVeiculoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VeiculosTable _veiculoIdTable(_$AppDatabase db) =>
      db.veiculos.createAlias('despesas_veiculo__veiculo_id__veiculos__id');

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
}

class $$DespesasVeiculoTableFilterComposer
    extends Composer<_$AppDatabase, $DespesasVeiculoTable> {
  $$DespesasVeiculoTableFilterComposer({
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

  ColumnWithTypeConverterFilters<TipoDespesaVeiculo, TipoDespesaVeiculo, String>
  get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
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

  ColumnFilters<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnFilters(column),
  );

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
}

class $$DespesasVeiculoTableOrderingComposer
    extends Composer<_$AppDatabase, $DespesasVeiculoTable> {
  $$DespesasVeiculoTableOrderingComposer({
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

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
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

  ColumnOrderings<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnOrderings(column),
  );

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

class $$DespesasVeiculoTableAnnotationComposer
    extends Composer<_$AppDatabase, $DespesasVeiculoTable> {
  $$DespesasVeiculoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoDespesaVeiculo, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<int> get valorCentavos => $composableBuilder(
    column: $table.valorCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataHora =>
      $composableBuilder(column: $table.dataHora, builder: (column) => column);

  GeneratedColumn<String> get observacao => $composableBuilder(
    column: $table.observacao,
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
}

class $$DespesasVeiculoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DespesasVeiculoTable,
          DespesaVeiculo,
          $$DespesasVeiculoTableFilterComposer,
          $$DespesasVeiculoTableOrderingComposer,
          $$DespesasVeiculoTableAnnotationComposer,
          $$DespesasVeiculoTableCreateCompanionBuilder,
          $$DespesasVeiculoTableUpdateCompanionBuilder,
          (DespesaVeiculo, $$DespesasVeiculoTableReferences),
          DespesaVeiculo,
          PrefetchHooks Function({bool veiculoId})
        > {
  $$DespesasVeiculoTableTableManager(
    _$AppDatabase db,
    $DespesasVeiculoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DespesasVeiculoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DespesasVeiculoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DespesasVeiculoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> veiculoId = const Value.absent(),
                Value<TipoDespesaVeiculo> tipo = const Value.absent(),
                Value<String> descricao = const Value.absent(),
                Value<int> valorCentavos = const Value.absent(),
                Value<DateTime> dataHora = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime?> dataAtualizacao = const Value.absent(),
              }) => DespesasVeiculoCompanion(
                id: id,
                veiculoId: veiculoId,
                tipo: tipo,
                descricao: descricao,
                valorCentavos: valorCentavos,
                dataHora: dataHora,
                observacao: observacao,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int veiculoId,
                required TipoDespesaVeiculo tipo,
                required String descricao,
                required int valorCentavos,
                required DateTime dataHora,
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime?> dataAtualizacao = const Value.absent(),
              }) => DespesasVeiculoCompanion.insert(
                id: id,
                veiculoId: veiculoId,
                tipo: tipo,
                descricao: descricao,
                valorCentavos: valorCentavos,
                dataHora: dataHora,
                observacao: observacao,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DespesasVeiculoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({veiculoId = false}) {
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
                    if (veiculoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.veiculoId,
                                referencedTable:
                                    $$DespesasVeiculoTableReferences
                                        ._veiculoIdTable(db),
                                referencedColumn:
                                    $$DespesasVeiculoTableReferences
                                        ._veiculoIdTable(db)
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

typedef $$DespesasVeiculoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DespesasVeiculoTable,
      DespesaVeiculo,
      $$DespesasVeiculoTableFilterComposer,
      $$DespesasVeiculoTableOrderingComposer,
      $$DespesasVeiculoTableAnnotationComposer,
      $$DespesasVeiculoTableCreateCompanionBuilder,
      $$DespesasVeiculoTableUpdateCompanionBuilder,
      (DespesaVeiculo, $$DespesasVeiculoTableReferences),
      DespesaVeiculo,
      PrefetchHooks Function({bool veiculoId})
    >;
typedef $$CustosRecorrentesTableCreateCompanionBuilder =
    CustosRecorrentesCompanion Function({
      Value<int> id,
      required TipoCustoRecorrente tipo,
      required String descricao,
      required EscopoCustoRecorrente escopo,
      Value<int?> veiculoId,
      Value<int?> plataformaId,
      Value<int?> valorReferenciaCentavos,
      Value<bool> valorEstimado,
      required int periodicidadeMeses,
      Value<int> parcelasPorCiclo,
      Value<bool> ativo,
      Value<int?> quantidadeCiclosPrevista,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
      Value<DateTime?> dataAtualizacao,
    });
typedef $$CustosRecorrentesTableUpdateCompanionBuilder =
    CustosRecorrentesCompanion Function({
      Value<int> id,
      Value<TipoCustoRecorrente> tipo,
      Value<String> descricao,
      Value<EscopoCustoRecorrente> escopo,
      Value<int?> veiculoId,
      Value<int?> plataformaId,
      Value<int?> valorReferenciaCentavos,
      Value<bool> valorEstimado,
      Value<int> periodicidadeMeses,
      Value<int> parcelasPorCiclo,
      Value<bool> ativo,
      Value<int?> quantidadeCiclosPrevista,
      Value<String?> observacao,
      Value<DateTime> dataCriacao,
      Value<DateTime?> dataAtualizacao,
    });

final class $$CustosRecorrentesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CustosRecorrentesTable,
          CustoRecorrente
        > {
  $$CustosRecorrentesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VeiculosTable _veiculoIdTable(_$AppDatabase db) =>
      db.veiculos.createAlias('custos_recorrentes__veiculo_id__veiculos__id');

  $$VeiculosTableProcessedTableManager? get veiculoId {
    final $_column = $_itemColumn<int>('veiculo_id');
    if ($_column == null) return null;
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

  static $PlataformasTable _plataformaIdTable(_$AppDatabase db) => db
      .plataformas
      .createAlias('custos_recorrentes__plataforma_id__plataformas__id');

  $$PlataformasTableProcessedTableManager? get plataformaId {
    final $_column = $_itemColumn<int>('plataforma_id');
    if ($_column == null) return null;
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

class $$CustosRecorrentesTableFilterComposer
    extends Composer<_$AppDatabase, $CustosRecorrentesTable> {
  $$CustosRecorrentesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<
    TipoCustoRecorrente,
    TipoCustoRecorrente,
    String
  >
  get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    EscopoCustoRecorrente,
    EscopoCustoRecorrente,
    String
  >
  get escopo => $composableBuilder(
    column: $table.escopo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get valorReferenciaCentavos => $composableBuilder(
    column: $table.valorReferenciaCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get valorEstimado => $composableBuilder(
    column: $table.valorEstimado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get periodicidadeMeses => $composableBuilder(
    column: $table.periodicidadeMeses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parcelasPorCiclo => $composableBuilder(
    column: $table.parcelasPorCiclo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantidadeCiclosPrevista => $composableBuilder(
    column: $table.quantidadeCiclosPrevista,
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

  ColumnFilters<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnFilters(column),
  );

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

class $$CustosRecorrentesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustosRecorrentesTable> {
  $$CustosRecorrentesTableOrderingComposer({
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

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get escopo => $composableBuilder(
    column: $table.escopo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorReferenciaCentavos => $composableBuilder(
    column: $table.valorReferenciaCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get valorEstimado => $composableBuilder(
    column: $table.valorEstimado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get periodicidadeMeses => $composableBuilder(
    column: $table.periodicidadeMeses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parcelasPorCiclo => $composableBuilder(
    column: $table.parcelasPorCiclo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantidadeCiclosPrevista => $composableBuilder(
    column: $table.quantidadeCiclosPrevista,
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

  ColumnOrderings<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnOrderings(column),
  );

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

class $$CustosRecorrentesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustosRecorrentesTable> {
  $$CustosRecorrentesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoCustoRecorrente, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EscopoCustoRecorrente, String> get escopo =>
      $composableBuilder(column: $table.escopo, builder: (column) => column);

  GeneratedColumn<int> get valorReferenciaCentavos => $composableBuilder(
    column: $table.valorReferenciaCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get valorEstimado => $composableBuilder(
    column: $table.valorEstimado,
    builder: (column) => column,
  );

  GeneratedColumn<int> get periodicidadeMeses => $composableBuilder(
    column: $table.periodicidadeMeses,
    builder: (column) => column,
  );

  GeneratedColumn<int> get parcelasPorCiclo => $composableBuilder(
    column: $table.parcelasPorCiclo,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  GeneratedColumn<int> get quantidadeCiclosPrevista => $composableBuilder(
    column: $table.quantidadeCiclosPrevista,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacao => $composableBuilder(
    column: $table.observacao,
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

class $$CustosRecorrentesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustosRecorrentesTable,
          CustoRecorrente,
          $$CustosRecorrentesTableFilterComposer,
          $$CustosRecorrentesTableOrderingComposer,
          $$CustosRecorrentesTableAnnotationComposer,
          $$CustosRecorrentesTableCreateCompanionBuilder,
          $$CustosRecorrentesTableUpdateCompanionBuilder,
          (CustoRecorrente, $$CustosRecorrentesTableReferences),
          CustoRecorrente,
          PrefetchHooks Function({bool veiculoId, bool plataformaId})
        > {
  $$CustosRecorrentesTableTableManager(
    _$AppDatabase db,
    $CustosRecorrentesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustosRecorrentesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustosRecorrentesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustosRecorrentesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<TipoCustoRecorrente> tipo = const Value.absent(),
                Value<String> descricao = const Value.absent(),
                Value<EscopoCustoRecorrente> escopo = const Value.absent(),
                Value<int?> veiculoId = const Value.absent(),
                Value<int?> plataformaId = const Value.absent(),
                Value<int?> valorReferenciaCentavos = const Value.absent(),
                Value<bool> valorEstimado = const Value.absent(),
                Value<int> periodicidadeMeses = const Value.absent(),
                Value<int> parcelasPorCiclo = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<int?> quantidadeCiclosPrevista = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime?> dataAtualizacao = const Value.absent(),
              }) => CustosRecorrentesCompanion(
                id: id,
                tipo: tipo,
                descricao: descricao,
                escopo: escopo,
                veiculoId: veiculoId,
                plataformaId: plataformaId,
                valorReferenciaCentavos: valorReferenciaCentavos,
                valorEstimado: valorEstimado,
                periodicidadeMeses: periodicidadeMeses,
                parcelasPorCiclo: parcelasPorCiclo,
                ativo: ativo,
                quantidadeCiclosPrevista: quantidadeCiclosPrevista,
                observacao: observacao,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required TipoCustoRecorrente tipo,
                required String descricao,
                required EscopoCustoRecorrente escopo,
                Value<int?> veiculoId = const Value.absent(),
                Value<int?> plataformaId = const Value.absent(),
                Value<int?> valorReferenciaCentavos = const Value.absent(),
                Value<bool> valorEstimado = const Value.absent(),
                required int periodicidadeMeses,
                Value<int> parcelasPorCiclo = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<int?> quantidadeCiclosPrevista = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime?> dataAtualizacao = const Value.absent(),
              }) => CustosRecorrentesCompanion.insert(
                id: id,
                tipo: tipo,
                descricao: descricao,
                escopo: escopo,
                veiculoId: veiculoId,
                plataformaId: plataformaId,
                valorReferenciaCentavos: valorReferenciaCentavos,
                valorEstimado: valorEstimado,
                periodicidadeMeses: periodicidadeMeses,
                parcelasPorCiclo: parcelasPorCiclo,
                ativo: ativo,
                quantidadeCiclosPrevista: quantidadeCiclosPrevista,
                observacao: observacao,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustosRecorrentesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({veiculoId = false, plataformaId = false}) {
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
                    if (veiculoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.veiculoId,
                                referencedTable:
                                    $$CustosRecorrentesTableReferences
                                        ._veiculoIdTable(db),
                                referencedColumn:
                                    $$CustosRecorrentesTableReferences
                                        ._veiculoIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (plataformaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.plataformaId,
                                referencedTable:
                                    $$CustosRecorrentesTableReferences
                                        ._plataformaIdTable(db),
                                referencedColumn:
                                    $$CustosRecorrentesTableReferences
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

typedef $$CustosRecorrentesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustosRecorrentesTable,
      CustoRecorrente,
      $$CustosRecorrentesTableFilterComposer,
      $$CustosRecorrentesTableOrderingComposer,
      $$CustosRecorrentesTableAnnotationComposer,
      $$CustosRecorrentesTableCreateCompanionBuilder,
      $$CustosRecorrentesTableUpdateCompanionBuilder,
      (CustoRecorrente, $$CustosRecorrentesTableReferences),
      CustoRecorrente,
      PrefetchHooks Function({bool veiculoId, bool plataformaId})
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
  $$LeiturasGanhosTableTableManager get leiturasGanhos =>
      $$LeiturasGanhosTableTableManager(_db, _db.leiturasGanhos);
  $$LeiturasGanhoPlataformaTableTableManager get leiturasGanhoPlataforma =>
      $$LeiturasGanhoPlataformaTableTableManager(
        _db,
        _db.leiturasGanhoPlataforma,
      );
  $$LancamentosGanhoIndividualTableTableManager
  get lancamentosGanhoIndividual =>
      $$LancamentosGanhoIndividualTableTableManager(
        _db,
        _db.lancamentosGanhoIndividual,
      );
  $$AbastecimentosTableTableManager get abastecimentos =>
      $$AbastecimentosTableTableManager(_db, _db.abastecimentos);
  $$PassesPlataformaTableTableManager get passesPlataforma =>
      $$PassesPlataformaTableTableManager(_db, _db.passesPlataforma);
  $$BonusPromocoesTableTableManager get bonusPromocoes =>
      $$BonusPromocoesTableTableManager(_db, _db.bonusPromocoes);
  $$ManutencoesTableTableManager get manutencoes =>
      $$ManutencoesTableTableManager(_db, _db.manutencoes);
  $$ItensManutencaoTableTableManager get itensManutencao =>
      $$ItensManutencaoTableTableManager(_db, _db.itensManutencao);
  $$DespesasVeiculoTableTableManager get despesasVeiculo =>
      $$DespesasVeiculoTableTableManager(_db, _db.despesasVeiculo);
  $$CustosRecorrentesTableTableManager get custosRecorrentes =>
      $$CustosRecorrentesTableTableManager(_db, _db.custosRecorrentes);
}
