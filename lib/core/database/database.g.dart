// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
    'avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _badgesMeta = const VerificationMeta('badges');
  @override
  late final GeneratedColumn<String> badges = GeneratedColumn<String>(
    'badges',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _isPremiumMeta = const VerificationMeta(
    'isPremium',
  );
  @override
  late final GeneratedColumn<bool> isPremium = GeneratedColumn<bool>(
    'is_premium',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_premium" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('fr'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    firstName,
    lastName,
    avatar,
    xp,
    level,
    badges,
    isPremium,
    country,
    phone,
    language,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('badges')) {
      context.handle(
        _badgesMeta,
        badges.isAcceptableOrUnknown(data['badges']!, _badgesMeta),
      );
    }
    if (data.containsKey('is_premium')) {
      context.handle(
        _isPremiumMeta,
        isPremium.isAcceptableOrUnknown(data['is_premium']!, _isPremiumMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      ),
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      badges: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}badges'],
      )!,
      isPremium: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_premium'],
      )!,
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? avatar;
  final int xp;
  final int level;
  final String badges;
  final bool isPremium;
  final String? country;
  final String? phone;
  final String language;
  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.avatar,
    required this.xp,
    required this.level,
    required this.badges,
    required this.isPremium,
    this.country,
    this.phone,
    required this.language,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    map['xp'] = Variable<int>(xp);
    map['level'] = Variable<int>(level);
    map['badges'] = Variable<String>(badges);
    map['is_premium'] = Variable<bool>(isPremium);
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['language'] = Variable<String>(language);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      firstName: Value(firstName),
      lastName: Value(lastName),
      avatar: avatar == null && nullToAbsent
          ? const Value.absent()
          : Value(avatar),
      xp: Value(xp),
      level: Value(level),
      badges: Value(badges),
      isPremium: Value(isPremium),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      language: Value(language),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      xp: serializer.fromJson<int>(json['xp']),
      level: serializer.fromJson<int>(json['level']),
      badges: serializer.fromJson<String>(json['badges']),
      isPremium: serializer.fromJson<bool>(json['isPremium']),
      country: serializer.fromJson<String?>(json['country']),
      phone: serializer.fromJson<String?>(json['phone']),
      language: serializer.fromJson<String>(json['language']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'avatar': serializer.toJson<String?>(avatar),
      'xp': serializer.toJson<int>(xp),
      'level': serializer.toJson<int>(level),
      'badges': serializer.toJson<String>(badges),
      'isPremium': serializer.toJson<bool>(isPremium),
      'country': serializer.toJson<String?>(country),
      'phone': serializer.toJson<String?>(phone),
      'language': serializer.toJson<String>(language),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    Value<String?> avatar = const Value.absent(),
    int? xp,
    int? level,
    String? badges,
    bool? isPremium,
    Value<String?> country = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    String? language,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    avatar: avatar.present ? avatar.value : this.avatar,
    xp: xp ?? this.xp,
    level: level ?? this.level,
    badges: badges ?? this.badges,
    isPremium: isPremium ?? this.isPremium,
    country: country.present ? country.value : this.country,
    phone: phone.present ? phone.value : this.phone,
    language: language ?? this.language,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      xp: data.xp.present ? data.xp.value : this.xp,
      level: data.level.present ? data.level.value : this.level,
      badges: data.badges.present ? data.badges.value : this.badges,
      isPremium: data.isPremium.present ? data.isPremium.value : this.isPremium,
      country: data.country.present ? data.country.value : this.country,
      phone: data.phone.present ? data.phone.value : this.phone,
      language: data.language.present ? data.language.value : this.language,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('avatar: $avatar, ')
          ..write('xp: $xp, ')
          ..write('level: $level, ')
          ..write('badges: $badges, ')
          ..write('isPremium: $isPremium, ')
          ..write('country: $country, ')
          ..write('phone: $phone, ')
          ..write('language: $language')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    firstName,
    lastName,
    avatar,
    xp,
    level,
    badges,
    isPremium,
    country,
    phone,
    language,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.email == this.email &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.avatar == this.avatar &&
          other.xp == this.xp &&
          other.level == this.level &&
          other.badges == this.badges &&
          other.isPremium == this.isPremium &&
          other.country == this.country &&
          other.phone == this.phone &&
          other.language == this.language);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> avatar;
  final Value<int> xp;
  final Value<int> level;
  final Value<String> badges;
  final Value<bool> isPremium;
  final Value<String?> country;
  final Value<String?> phone;
  final Value<String> language;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.avatar = const Value.absent(),
    this.xp = const Value.absent(),
    this.level = const Value.absent(),
    this.badges = const Value.absent(),
    this.isPremium = const Value.absent(),
    this.country = const Value.absent(),
    this.phone = const Value.absent(),
    this.language = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    this.avatar = const Value.absent(),
    this.xp = const Value.absent(),
    this.level = const Value.absent(),
    this.badges = const Value.absent(),
    this.isPremium = const Value.absent(),
    this.country = const Value.absent(),
    this.phone = const Value.absent(),
    this.language = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       firstName = Value(firstName),
       lastName = Value(lastName);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? avatar,
    Expression<int>? xp,
    Expression<int>? level,
    Expression<String>? badges,
    Expression<bool>? isPremium,
    Expression<String>? country,
    Expression<String>? phone,
    Expression<String>? language,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (avatar != null) 'avatar': avatar,
      if (xp != null) 'xp': xp,
      if (level != null) 'level': level,
      if (badges != null) 'badges': badges,
      if (isPremium != null) 'is_premium': isPremium,
      if (country != null) 'country': country,
      if (phone != null) 'phone': phone,
      if (language != null) 'language': language,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String?>? avatar,
    Value<int>? xp,
    Value<int>? level,
    Value<String>? badges,
    Value<bool>? isPremium,
    Value<String?>? country,
    Value<String?>? phone,
    Value<String>? language,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      isPremium: isPremium ?? this.isPremium,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      language: language ?? this.language,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (badges.present) {
      map['badges'] = Variable<String>(badges.value);
    }
    if (isPremium.present) {
      map['is_premium'] = Variable<bool>(isPremium.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('avatar: $avatar, ')
          ..write('xp: $xp, ')
          ..write('level: $level, ')
          ..write('badges: $badges, ')
          ..write('isPremium: $isPremium, ')
          ..write('country: $country, ')
          ..write('phone: $phone, ')
          ..write('language: $language, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('XAF'),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subcategoryMeta = const VerificationMeta(
    'subcategory',
  );
  @override
  late final GeneratedColumn<String> subcategory = GeneratedColumn<String>(
    'subcategory',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('completed'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _isRecurringMeta = const VerificationMeta(
    'isRecurring',
  );
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
    'is_recurring',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_recurring" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _recurringFrequencyMeta =
      const VerificationMeta('recurringFrequency');
  @override
  late final GeneratedColumn<String> recurringFrequency =
      GeneratedColumn<String>(
        'recurring_frequency',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isAutoCategorizedMeta = const VerificationMeta(
    'isAutoCategorized',
  );
  @override
  late final GeneratedColumn<bool> isAutoCategorized = GeneratedColumn<bool>(
    'is_auto_categorized',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_auto_categorized" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _categorizationConfidenceMeta =
      const VerificationMeta('categorizationConfidence');
  @override
  late final GeneratedColumn<double> categorizationConfidence =
      GeneratedColumn<double>(
        'categorization_confidence',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _receiptMeta = const VerificationMeta(
    'receipt',
  );
  @override
  late final GeneratedColumn<String> receipt = GeneratedColumn<String>(
    'receipt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedGoalIdMeta = const VerificationMeta(
    'linkedGoalId',
  );
  @override
  late final GeneratedColumn<String> linkedGoalId = GeneratedColumn<String>(
    'linked_goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    amount,
    currency,
    type,
    category,
    subcategory,
    description,
    merchant,
    location,
    date,
    status,
    source,
    tags,
    isRecurring,
    recurringFrequency,
    isAutoCategorized,
    categorizationConfidence,
    receipt,
    linkedGoalId,
    metadata,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('subcategory')) {
      context.handle(
        _subcategoryMeta,
        subcategory.isAcceptableOrUnknown(
          data['subcategory']!,
          _subcategoryMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
        _isRecurringMeta,
        isRecurring.isAcceptableOrUnknown(
          data['is_recurring']!,
          _isRecurringMeta,
        ),
      );
    }
    if (data.containsKey('recurring_frequency')) {
      context.handle(
        _recurringFrequencyMeta,
        recurringFrequency.isAcceptableOrUnknown(
          data['recurring_frequency']!,
          _recurringFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('is_auto_categorized')) {
      context.handle(
        _isAutoCategorizedMeta,
        isAutoCategorized.isAcceptableOrUnknown(
          data['is_auto_categorized']!,
          _isAutoCategorizedMeta,
        ),
      );
    }
    if (data.containsKey('categorization_confidence')) {
      context.handle(
        _categorizationConfidenceMeta,
        categorizationConfidence.isAcceptableOrUnknown(
          data['categorization_confidence']!,
          _categorizationConfidenceMeta,
        ),
      );
    }
    if (data.containsKey('receipt')) {
      context.handle(
        _receiptMeta,
        receipt.isAcceptableOrUnknown(data['receipt']!, _receiptMeta),
      );
    }
    if (data.containsKey('linked_goal_id')) {
      context.handle(
        _linkedGoalIdMeta,
        linkedGoalId.isAcceptableOrUnknown(
          data['linked_goal_id']!,
          _linkedGoalIdMeta,
        ),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      subcategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subcategory'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      isRecurring: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_recurring'],
      )!,
      recurringFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_frequency'],
      ),
      isAutoCategorized: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_auto_categorized'],
      )!,
      categorizationConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}categorization_confidence'],
      ),
      receipt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt'],
      ),
      linkedGoalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_goal_id'],
      ),
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String? userId;
  final double amount;
  final String currency;
  final String type;
  final String category;
  final String? subcategory;
  final String description;
  final String? merchant;
  final String? location;
  final DateTime date;
  final String status;
  final String? source;
  final String tags;
  final bool isRecurring;
  final String? recurringFrequency;
  final bool isAutoCategorized;
  final double? categorizationConfidence;
  final String? receipt;
  final String? linkedGoalId;
  final String? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const Transaction({
    required this.id,
    this.userId,
    required this.amount,
    required this.currency,
    required this.type,
    required this.category,
    this.subcategory,
    required this.description,
    this.merchant,
    this.location,
    required this.date,
    required this.status,
    this.source,
    required this.tags,
    required this.isRecurring,
    this.recurringFrequency,
    required this.isAutoCategorized,
    this.categorizationConfidence,
    this.receipt,
    this.linkedGoalId,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || subcategory != null) {
      map['subcategory'] = Variable<String>(subcategory);
    }
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || merchant != null) {
      map['merchant'] = Variable<String>(merchant);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['date'] = Variable<DateTime>(date);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['tags'] = Variable<String>(tags);
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || recurringFrequency != null) {
      map['recurring_frequency'] = Variable<String>(recurringFrequency);
    }
    map['is_auto_categorized'] = Variable<bool>(isAutoCategorized);
    if (!nullToAbsent || categorizationConfidence != null) {
      map['categorization_confidence'] = Variable<double>(
        categorizationConfidence,
      );
    }
    if (!nullToAbsent || receipt != null) {
      map['receipt'] = Variable<String>(receipt);
    }
    if (!nullToAbsent || linkedGoalId != null) {
      map['linked_goal_id'] = Variable<String>(linkedGoalId);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      amount: Value(amount),
      currency: Value(currency),
      type: Value(type),
      category: Value(category),
      subcategory: subcategory == null && nullToAbsent
          ? const Value.absent()
          : Value(subcategory),
      description: Value(description),
      merchant: merchant == null && nullToAbsent
          ? const Value.absent()
          : Value(merchant),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      date: Value(date),
      status: Value(status),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      tags: Value(tags),
      isRecurring: Value(isRecurring),
      recurringFrequency: recurringFrequency == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringFrequency),
      isAutoCategorized: Value(isAutoCategorized),
      categorizationConfidence: categorizationConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(categorizationConfidence),
      receipt: receipt == null && nullToAbsent
          ? const Value.absent()
          : Value(receipt),
      linkedGoalId: linkedGoalId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedGoalId),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      subcategory: serializer.fromJson<String?>(json['subcategory']),
      description: serializer.fromJson<String>(json['description']),
      merchant: serializer.fromJson<String?>(json['merchant']),
      location: serializer.fromJson<String?>(json['location']),
      date: serializer.fromJson<DateTime>(json['date']),
      status: serializer.fromJson<String>(json['status']),
      source: serializer.fromJson<String?>(json['source']),
      tags: serializer.fromJson<String>(json['tags']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurringFrequency: serializer.fromJson<String?>(
        json['recurringFrequency'],
      ),
      isAutoCategorized: serializer.fromJson<bool>(json['isAutoCategorized']),
      categorizationConfidence: serializer.fromJson<double?>(
        json['categorizationConfidence'],
      ),
      receipt: serializer.fromJson<String?>(json['receipt']),
      linkedGoalId: serializer.fromJson<String?>(json['linkedGoalId']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'subcategory': serializer.toJson<String?>(subcategory),
      'description': serializer.toJson<String>(description),
      'merchant': serializer.toJson<String?>(merchant),
      'location': serializer.toJson<String?>(location),
      'date': serializer.toJson<DateTime>(date),
      'status': serializer.toJson<String>(status),
      'source': serializer.toJson<String?>(source),
      'tags': serializer.toJson<String>(tags),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurringFrequency': serializer.toJson<String?>(recurringFrequency),
      'isAutoCategorized': serializer.toJson<bool>(isAutoCategorized),
      'categorizationConfidence': serializer.toJson<double?>(
        categorizationConfidence,
      ),
      'receipt': serializer.toJson<String?>(receipt),
      'linkedGoalId': serializer.toJson<String?>(linkedGoalId),
      'metadata': serializer.toJson<String?>(metadata),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Transaction copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    double? amount,
    String? currency,
    String? type,
    String? category,
    Value<String?> subcategory = const Value.absent(),
    String? description,
    Value<String?> merchant = const Value.absent(),
    Value<String?> location = const Value.absent(),
    DateTime? date,
    String? status,
    Value<String?> source = const Value.absent(),
    String? tags,
    bool? isRecurring,
    Value<String?> recurringFrequency = const Value.absent(),
    bool? isAutoCategorized,
    Value<double?> categorizationConfidence = const Value.absent(),
    Value<String?> receipt = const Value.absent(),
    Value<String?> linkedGoalId = const Value.absent(),
    Value<String?> metadata = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Transaction(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    type: type ?? this.type,
    category: category ?? this.category,
    subcategory: subcategory.present ? subcategory.value : this.subcategory,
    description: description ?? this.description,
    merchant: merchant.present ? merchant.value : this.merchant,
    location: location.present ? location.value : this.location,
    date: date ?? this.date,
    status: status ?? this.status,
    source: source.present ? source.value : this.source,
    tags: tags ?? this.tags,
    isRecurring: isRecurring ?? this.isRecurring,
    recurringFrequency: recurringFrequency.present
        ? recurringFrequency.value
        : this.recurringFrequency,
    isAutoCategorized: isAutoCategorized ?? this.isAutoCategorized,
    categorizationConfidence: categorizationConfidence.present
        ? categorizationConfidence.value
        : this.categorizationConfidence,
    receipt: receipt.present ? receipt.value : this.receipt,
    linkedGoalId: linkedGoalId.present ? linkedGoalId.value : this.linkedGoalId,
    metadata: metadata.present ? metadata.value : this.metadata,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      subcategory: data.subcategory.present
          ? data.subcategory.value
          : this.subcategory,
      description: data.description.present
          ? data.description.value
          : this.description,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      location: data.location.present ? data.location.value : this.location,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      source: data.source.present ? data.source.value : this.source,
      tags: data.tags.present ? data.tags.value : this.tags,
      isRecurring: data.isRecurring.present
          ? data.isRecurring.value
          : this.isRecurring,
      recurringFrequency: data.recurringFrequency.present
          ? data.recurringFrequency.value
          : this.recurringFrequency,
      isAutoCategorized: data.isAutoCategorized.present
          ? data.isAutoCategorized.value
          : this.isAutoCategorized,
      categorizationConfidence: data.categorizationConfidence.present
          ? data.categorizationConfidence.value
          : this.categorizationConfidence,
      receipt: data.receipt.present ? data.receipt.value : this.receipt,
      linkedGoalId: data.linkedGoalId.present
          ? data.linkedGoalId.value
          : this.linkedGoalId,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('subcategory: $subcategory, ')
          ..write('description: $description, ')
          ..write('merchant: $merchant, ')
          ..write('location: $location, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('tags: $tags, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringFrequency: $recurringFrequency, ')
          ..write('isAutoCategorized: $isAutoCategorized, ')
          ..write('categorizationConfidence: $categorizationConfidence, ')
          ..write('receipt: $receipt, ')
          ..write('linkedGoalId: $linkedGoalId, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    amount,
    currency,
    type,
    category,
    subcategory,
    description,
    merchant,
    location,
    date,
    status,
    source,
    tags,
    isRecurring,
    recurringFrequency,
    isAutoCategorized,
    categorizationConfidence,
    receipt,
    linkedGoalId,
    metadata,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.type == this.type &&
          other.category == this.category &&
          other.subcategory == this.subcategory &&
          other.description == this.description &&
          other.merchant == this.merchant &&
          other.location == this.location &&
          other.date == this.date &&
          other.status == this.status &&
          other.source == this.source &&
          other.tags == this.tags &&
          other.isRecurring == this.isRecurring &&
          other.recurringFrequency == this.recurringFrequency &&
          other.isAutoCategorized == this.isAutoCategorized &&
          other.categorizationConfidence == this.categorizationConfidence &&
          other.receipt == this.receipt &&
          other.linkedGoalId == this.linkedGoalId &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<double> amount;
  final Value<String> currency;
  final Value<String> type;
  final Value<String> category;
  final Value<String?> subcategory;
  final Value<String> description;
  final Value<String?> merchant;
  final Value<String?> location;
  final Value<DateTime> date;
  final Value<String> status;
  final Value<String?> source;
  final Value<String> tags;
  final Value<bool> isRecurring;
  final Value<String?> recurringFrequency;
  final Value<bool> isAutoCategorized;
  final Value<double?> categorizationConfidence;
  final Value<String?> receipt;
  final Value<String?> linkedGoalId;
  final Value<String?> metadata;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.subcategory = const Value.absent(),
    this.description = const Value.absent(),
    this.merchant = const Value.absent(),
    this.location = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.tags = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringFrequency = const Value.absent(),
    this.isAutoCategorized = const Value.absent(),
    this.categorizationConfidence = const Value.absent(),
    this.receipt = const Value.absent(),
    this.linkedGoalId = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required double amount,
    this.currency = const Value.absent(),
    required String type,
    required String category,
    this.subcategory = const Value.absent(),
    required String description,
    this.merchant = const Value.absent(),
    this.location = const Value.absent(),
    required DateTime date,
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.tags = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringFrequency = const Value.absent(),
    this.isAutoCategorized = const Value.absent(),
    this.categorizationConfidence = const Value.absent(),
    this.receipt = const Value.absent(),
    this.linkedGoalId = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       type = Value(type),
       category = Value(category),
       description = Value(description),
       date = Value(date);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<String>? type,
    Expression<String>? category,
    Expression<String>? subcategory,
    Expression<String>? description,
    Expression<String>? merchant,
    Expression<String>? location,
    Expression<DateTime>? date,
    Expression<String>? status,
    Expression<String>? source,
    Expression<String>? tags,
    Expression<bool>? isRecurring,
    Expression<String>? recurringFrequency,
    Expression<bool>? isAutoCategorized,
    Expression<double>? categorizationConfidence,
    Expression<String>? receipt,
    Expression<String>? linkedGoalId,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (subcategory != null) 'subcategory': subcategory,
      if (description != null) 'description': description,
      if (merchant != null) 'merchant': merchant,
      if (location != null) 'location': location,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (tags != null) 'tags': tags,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (recurringFrequency != null) 'recurring_frequency': recurringFrequency,
      if (isAutoCategorized != null) 'is_auto_categorized': isAutoCategorized,
      if (categorizationConfidence != null)
        'categorization_confidence': categorizationConfidence,
      if (receipt != null) 'receipt': receipt,
      if (linkedGoalId != null) 'linked_goal_id': linkedGoalId,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<double>? amount,
    Value<String>? currency,
    Value<String>? type,
    Value<String>? category,
    Value<String?>? subcategory,
    Value<String>? description,
    Value<String?>? merchant,
    Value<String?>? location,
    Value<DateTime>? date,
    Value<String>? status,
    Value<String?>? source,
    Value<String>? tags,
    Value<bool>? isRecurring,
    Value<String?>? recurringFrequency,
    Value<bool>? isAutoCategorized,
    Value<double?>? categorizationConfidence,
    Value<String?>? receipt,
    Value<String?>? linkedGoalId,
    Value<String?>? metadata,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      type: type ?? this.type,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      description: description ?? this.description,
      merchant: merchant ?? this.merchant,
      location: location ?? this.location,
      date: date ?? this.date,
      status: status ?? this.status,
      source: source ?? this.source,
      tags: tags ?? this.tags,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringFrequency: recurringFrequency ?? this.recurringFrequency,
      isAutoCategorized: isAutoCategorized ?? this.isAutoCategorized,
      categorizationConfidence:
          categorizationConfidence ?? this.categorizationConfidence,
      receipt: receipt ?? this.receipt,
      linkedGoalId: linkedGoalId ?? this.linkedGoalId,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (subcategory.present) {
      map['subcategory'] = Variable<String>(subcategory.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (recurringFrequency.present) {
      map['recurring_frequency'] = Variable<String>(recurringFrequency.value);
    }
    if (isAutoCategorized.present) {
      map['is_auto_categorized'] = Variable<bool>(isAutoCategorized.value);
    }
    if (categorizationConfidence.present) {
      map['categorization_confidence'] = Variable<double>(
        categorizationConfidence.value,
      );
    }
    if (receipt.present) {
      map['receipt'] = Variable<String>(receipt.value);
    }
    if (linkedGoalId.present) {
      map['linked_goal_id'] = Variable<String>(linkedGoalId.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('subcategory: $subcategory, ')
          ..write('description: $description, ')
          ..write('merchant: $merchant, ')
          ..write('location: $location, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('tags: $tags, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringFrequency: $recurringFrequency, ')
          ..write('isAutoCategorized: $isAutoCategorized, ')
          ..write('categorizationConfidence: $categorizationConfidence, ')
          ..write('receipt: $receipt, ')
          ..write('linkedGoalId: $linkedGoalId, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriesMeta = const VerificationMeta(
    'categories',
  );
  @override
  late final GeneratedColumn<String> categories = GeneratedColumn<String>(
    'categories',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAllocatedMeta = const VerificationMeta(
    'totalAllocated',
  );
  @override
  late final GeneratedColumn<double> totalAllocated = GeneratedColumn<double>(
    'total_allocated',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalSpentMeta = const VerificationMeta(
    'totalSpent',
  );
  @override
  late final GeneratedColumn<double> totalSpent = GeneratedColumn<double>(
    'total_spent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    period,
    categories,
    totalAllocated,
    totalSpent,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Budget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('categories')) {
      context.handle(
        _categoriesMeta,
        categories.isAcceptableOrUnknown(data['categories']!, _categoriesMeta),
      );
    } else if (isInserting) {
      context.missing(_categoriesMeta);
    }
    if (data.containsKey('total_allocated')) {
      context.handle(
        _totalAllocatedMeta,
        totalAllocated.isAcceptableOrUnknown(
          data['total_allocated']!,
          _totalAllocatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAllocatedMeta);
    }
    if (data.containsKey('total_spent')) {
      context.handle(
        _totalSpentMeta,
        totalSpent.isAcceptableOrUnknown(data['total_spent']!, _totalSpentMeta),
      );
    } else if (isInserting) {
      context.missing(_totalSpentMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      categories: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categories'],
      )!,
      totalAllocated: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_allocated'],
      )!,
      totalSpent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_spent'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final String id;
  final String period;
  final String categories;
  final double totalAllocated;
  final double totalSpent;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const Budget({
    required this.id,
    required this.period,
    required this.categories,
    required this.totalAllocated,
    required this.totalSpent,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['period'] = Variable<String>(period);
    map['categories'] = Variable<String>(categories);
    map['total_allocated'] = Variable<double>(totalAllocated);
    map['total_spent'] = Variable<double>(totalSpent);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      period: Value(period),
      categories: Value(categories),
      totalAllocated: Value(totalAllocated),
      totalSpent: Value(totalSpent),
      status: Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Budget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<String>(json['id']),
      period: serializer.fromJson<String>(json['period']),
      categories: serializer.fromJson<String>(json['categories']),
      totalAllocated: serializer.fromJson<double>(json['totalAllocated']),
      totalSpent: serializer.fromJson<double>(json['totalSpent']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'period': serializer.toJson<String>(period),
      'categories': serializer.toJson<String>(categories),
      'totalAllocated': serializer.toJson<double>(totalAllocated),
      'totalSpent': serializer.toJson<double>(totalSpent),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Budget copyWith({
    String? id,
    String? period,
    String? categories,
    double? totalAllocated,
    double? totalSpent,
    String? status,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Budget(
    id: id ?? this.id,
    period: period ?? this.period,
    categories: categories ?? this.categories,
    totalAllocated: totalAllocated ?? this.totalAllocated,
    totalSpent: totalSpent ?? this.totalSpent,
    status: status ?? this.status,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      period: data.period.present ? data.period.value : this.period,
      categories: data.categories.present
          ? data.categories.value
          : this.categories,
      totalAllocated: data.totalAllocated.present
          ? data.totalAllocated.value
          : this.totalAllocated,
      totalSpent: data.totalSpent.present
          ? data.totalSpent.value
          : this.totalSpent,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('period: $period, ')
          ..write('categories: $categories, ')
          ..write('totalAllocated: $totalAllocated, ')
          ..write('totalSpent: $totalSpent, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    period,
    categories,
    totalAllocated,
    totalSpent,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.period == this.period &&
          other.categories == this.categories &&
          other.totalAllocated == this.totalAllocated &&
          other.totalSpent == this.totalSpent &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<String> id;
  final Value<String> period;
  final Value<String> categories;
  final Value<double> totalAllocated;
  final Value<double> totalSpent;
  final Value<String> status;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.period = const Value.absent(),
    this.categories = const Value.absent(),
    this.totalAllocated = const Value.absent(),
    this.totalSpent = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String id,
    required String period,
    required String categories,
    required double totalAllocated,
    required double totalSpent,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       period = Value(period),
       categories = Value(categories),
       totalAllocated = Value(totalAllocated),
       totalSpent = Value(totalSpent);
  static Insertable<Budget> custom({
    Expression<String>? id,
    Expression<String>? period,
    Expression<String>? categories,
    Expression<double>? totalAllocated,
    Expression<double>? totalSpent,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (period != null) 'period': period,
      if (categories != null) 'categories': categories,
      if (totalAllocated != null) 'total_allocated': totalAllocated,
      if (totalSpent != null) 'total_spent': totalSpent,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith({
    Value<String>? id,
    Value<String>? period,
    Value<String>? categories,
    Value<double>? totalAllocated,
    Value<double>? totalSpent,
    Value<String>? status,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      period: period ?? this.period,
      categories: categories ?? this.categories,
      totalAllocated: totalAllocated ?? this.totalAllocated,
      totalSpent: totalSpent ?? this.totalSpent,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (categories.present) {
      map['categories'] = Variable<String>(categories.value);
    }
    if (totalAllocated.present) {
      map['total_allocated'] = Variable<double>(totalAllocated.value);
    }
    if (totalSpent.present) {
      map['total_spent'] = Variable<double>(totalSpent.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('period: $period, ')
          ..write('categories: $categories, ')
          ..write('totalAllocated: $totalAllocated, ')
          ..write('totalSpent: $totalSpent, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('savings'),
  );
  static const VerificationMeta _targetAmountMeta = const VerificationMeta(
    'targetAmount',
  );
  @override
  late final GeneratedColumn<double> targetAmount = GeneratedColumn<double>(
    'target_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentAmountMeta = const VerificationMeta(
    'currentAmount',
  );
  @override
  late final GeneratedColumn<double> currentAmount = GeneratedColumn<double>(
    'current_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('XAF'),
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
    'deadline',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _strategyMeta = const VerificationMeta(
    'strategy',
  );
  @override
  late final GeneratedColumn<String> strategy = GeneratedColumn<String>(
    'strategy',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _autoSaveRulesMeta = const VerificationMeta(
    'autoSaveRules',
  );
  @override
  late final GeneratedColumn<String> autoSaveRules = GeneratedColumn<String>(
    'auto_save_rules',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSharedMeta = const VerificationMeta(
    'isShared',
  );
  @override
  late final GeneratedColumn<bool> isShared = GeneratedColumn<bool>(
    'is_shared',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_shared" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _participantsMeta = const VerificationMeta(
    'participants',
  );
  @override
  late final GeneratedColumn<String> participants = GeneratedColumn<String>(
    'participants',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    emoji,
    type,
    targetAmount,
    currentAmount,
    currency,
    deadline,
    category,
    status,
    strategy,
    autoSaveRules,
    isShared,
    participants,
    image,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('target_amount')) {
      context.handle(
        _targetAmountMeta,
        targetAmount.isAcceptableOrUnknown(
          data['target_amount']!,
          _targetAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('current_amount')) {
      context.handle(
        _currentAmountMeta,
        currentAmount.isAcceptableOrUnknown(
          data['current_amount']!,
          _currentAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentAmountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    } else if (isInserting) {
      context.missing(_deadlineMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('strategy')) {
      context.handle(
        _strategyMeta,
        strategy.isAcceptableOrUnknown(data['strategy']!, _strategyMeta),
      );
    }
    if (data.containsKey('auto_save_rules')) {
      context.handle(
        _autoSaveRulesMeta,
        autoSaveRules.isAcceptableOrUnknown(
          data['auto_save_rules']!,
          _autoSaveRulesMeta,
        ),
      );
    }
    if (data.containsKey('is_shared')) {
      context.handle(
        _isSharedMeta,
        isShared.isAcceptableOrUnknown(data['is_shared']!, _isSharedMeta),
      );
    }
    if (data.containsKey('participants')) {
      context.handle(
        _participantsMeta,
        participants.isAcceptableOrUnknown(
          data['participants']!,
          _participantsMeta,
        ),
      );
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      targetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_amount'],
      )!,
      currentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      strategy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strategy'],
      ),
      autoSaveRules: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auto_save_rules'],
      ),
      isShared: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_shared'],
      )!,
      participants: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}participants'],
      )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final String id;
  final String name;
  final String? description;
  final String? emoji;
  final String type;
  final double targetAmount;
  final double currentAmount;
  final String currency;
  final DateTime deadline;
  final String? category;
  final String status;
  final String? strategy;
  final String? autoSaveRules;
  final bool isShared;
  final String participants;
  final String? image;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Goal({
    required this.id,
    required this.name,
    this.description,
    this.emoji,
    required this.type,
    required this.targetAmount,
    required this.currentAmount,
    required this.currency,
    required this.deadline,
    this.category,
    required this.status,
    this.strategy,
    this.autoSaveRules,
    required this.isShared,
    required this.participants,
    this.image,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || emoji != null) {
      map['emoji'] = Variable<String>(emoji);
    }
    map['type'] = Variable<String>(type);
    map['target_amount'] = Variable<double>(targetAmount);
    map['current_amount'] = Variable<double>(currentAmount);
    map['currency'] = Variable<String>(currency);
    map['deadline'] = Variable<DateTime>(deadline);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || strategy != null) {
      map['strategy'] = Variable<String>(strategy);
    }
    if (!nullToAbsent || autoSaveRules != null) {
      map['auto_save_rules'] = Variable<String>(autoSaveRules);
    }
    map['is_shared'] = Variable<bool>(isShared);
    map['participants'] = Variable<String>(participants);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      emoji: emoji == null && nullToAbsent
          ? const Value.absent()
          : Value(emoji),
      type: Value(type),
      targetAmount: Value(targetAmount),
      currentAmount: Value(currentAmount),
      currency: Value(currency),
      deadline: Value(deadline),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      status: Value(status),
      strategy: strategy == null && nullToAbsent
          ? const Value.absent()
          : Value(strategy),
      autoSaveRules: autoSaveRules == null && nullToAbsent
          ? const Value.absent()
          : Value(autoSaveRules),
      isShared: Value(isShared),
      participants: Value(participants),
      image: image == null && nullToAbsent
          ? const Value.absent()
          : Value(image),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      emoji: serializer.fromJson<String?>(json['emoji']),
      type: serializer.fromJson<String>(json['type']),
      targetAmount: serializer.fromJson<double>(json['targetAmount']),
      currentAmount: serializer.fromJson<double>(json['currentAmount']),
      currency: serializer.fromJson<String>(json['currency']),
      deadline: serializer.fromJson<DateTime>(json['deadline']),
      category: serializer.fromJson<String?>(json['category']),
      status: serializer.fromJson<String>(json['status']),
      strategy: serializer.fromJson<String?>(json['strategy']),
      autoSaveRules: serializer.fromJson<String?>(json['autoSaveRules']),
      isShared: serializer.fromJson<bool>(json['isShared']),
      participants: serializer.fromJson<String>(json['participants']),
      image: serializer.fromJson<String?>(json['image']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'emoji': serializer.toJson<String?>(emoji),
      'type': serializer.toJson<String>(type),
      'targetAmount': serializer.toJson<double>(targetAmount),
      'currentAmount': serializer.toJson<double>(currentAmount),
      'currency': serializer.toJson<String>(currency),
      'deadline': serializer.toJson<DateTime>(deadline),
      'category': serializer.toJson<String?>(category),
      'status': serializer.toJson<String>(status),
      'strategy': serializer.toJson<String?>(strategy),
      'autoSaveRules': serializer.toJson<String?>(autoSaveRules),
      'isShared': serializer.toJson<bool>(isShared),
      'participants': serializer.toJson<String>(participants),
      'image': serializer.toJson<String?>(image),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Goal copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> emoji = const Value.absent(),
    String? type,
    double? targetAmount,
    double? currentAmount,
    String? currency,
    DateTime? deadline,
    Value<String?> category = const Value.absent(),
    String? status,
    Value<String?> strategy = const Value.absent(),
    Value<String?> autoSaveRules = const Value.absent(),
    bool? isShared,
    String? participants,
    Value<String?> image = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Goal(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    emoji: emoji.present ? emoji.value : this.emoji,
    type: type ?? this.type,
    targetAmount: targetAmount ?? this.targetAmount,
    currentAmount: currentAmount ?? this.currentAmount,
    currency: currency ?? this.currency,
    deadline: deadline ?? this.deadline,
    category: category.present ? category.value : this.category,
    status: status ?? this.status,
    strategy: strategy.present ? strategy.value : this.strategy,
    autoSaveRules: autoSaveRules.present
        ? autoSaveRules.value
        : this.autoSaveRules,
    isShared: isShared ?? this.isShared,
    participants: participants ?? this.participants,
    image: image.present ? image.value : this.image,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      type: data.type.present ? data.type.value : this.type,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      currency: data.currency.present ? data.currency.value : this.currency,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      category: data.category.present ? data.category.value : this.category,
      status: data.status.present ? data.status.value : this.status,
      strategy: data.strategy.present ? data.strategy.value : this.strategy,
      autoSaveRules: data.autoSaveRules.present
          ? data.autoSaveRules.value
          : this.autoSaveRules,
      isShared: data.isShared.present ? data.isShared.value : this.isShared,
      participants: data.participants.present
          ? data.participants.value
          : this.participants,
      image: data.image.present ? data.image.value : this.image,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('emoji: $emoji, ')
          ..write('type: $type, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('currency: $currency, ')
          ..write('deadline: $deadline, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('strategy: $strategy, ')
          ..write('autoSaveRules: $autoSaveRules, ')
          ..write('isShared: $isShared, ')
          ..write('participants: $participants, ')
          ..write('image: $image, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    emoji,
    type,
    targetAmount,
    currentAmount,
    currency,
    deadline,
    category,
    status,
    strategy,
    autoSaveRules,
    isShared,
    participants,
    image,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.emoji == this.emoji &&
          other.type == this.type &&
          other.targetAmount == this.targetAmount &&
          other.currentAmount == this.currentAmount &&
          other.currency == this.currency &&
          other.deadline == this.deadline &&
          other.category == this.category &&
          other.status == this.status &&
          other.strategy == this.strategy &&
          other.autoSaveRules == this.autoSaveRules &&
          other.isShared == this.isShared &&
          other.participants == this.participants &&
          other.image == this.image &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> emoji;
  final Value<String> type;
  final Value<double> targetAmount;
  final Value<double> currentAmount;
  final Value<String> currency;
  final Value<DateTime> deadline;
  final Value<String?> category;
  final Value<String> status;
  final Value<String?> strategy;
  final Value<String?> autoSaveRules;
  final Value<bool> isShared;
  final Value<String> participants;
  final Value<String?> image;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.emoji = const Value.absent(),
    this.type = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.deadline = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
    this.strategy = const Value.absent(),
    this.autoSaveRules = const Value.absent(),
    this.isShared = const Value.absent(),
    this.participants = const Value.absent(),
    this.image = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.emoji = const Value.absent(),
    this.type = const Value.absent(),
    required double targetAmount,
    required double currentAmount,
    this.currency = const Value.absent(),
    required DateTime deadline,
    this.category = const Value.absent(),
    this.status = const Value.absent(),
    this.strategy = const Value.absent(),
    this.autoSaveRules = const Value.absent(),
    this.isShared = const Value.absent(),
    this.participants = const Value.absent(),
    this.image = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       targetAmount = Value(targetAmount),
       currentAmount = Value(currentAmount),
       deadline = Value(deadline),
       createdAt = Value(createdAt);
  static Insertable<Goal> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? emoji,
    Expression<String>? type,
    Expression<double>? targetAmount,
    Expression<double>? currentAmount,
    Expression<String>? currency,
    Expression<DateTime>? deadline,
    Expression<String>? category,
    Expression<String>? status,
    Expression<String>? strategy,
    Expression<String>? autoSaveRules,
    Expression<bool>? isShared,
    Expression<String>? participants,
    Expression<String>? image,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (emoji != null) 'emoji': emoji,
      if (type != null) 'type': type,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (currency != null) 'currency': currency,
      if (deadline != null) 'deadline': deadline,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
      if (strategy != null) 'strategy': strategy,
      if (autoSaveRules != null) 'auto_save_rules': autoSaveRules,
      if (isShared != null) 'is_shared': isShared,
      if (participants != null) 'participants': participants,
      if (image != null) 'image': image,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? emoji,
    Value<String>? type,
    Value<double>? targetAmount,
    Value<double>? currentAmount,
    Value<String>? currency,
    Value<DateTime>? deadline,
    Value<String?>? category,
    Value<String>? status,
    Value<String?>? strategy,
    Value<String?>? autoSaveRules,
    Value<bool>? isShared,
    Value<String>? participants,
    Value<String?>? image,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      type: type ?? this.type,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      currency: currency ?? this.currency,
      deadline: deadline ?? this.deadline,
      category: category ?? this.category,
      status: status ?? this.status,
      strategy: strategy ?? this.strategy,
      autoSaveRules: autoSaveRules ?? this.autoSaveRules,
      isShared: isShared ?? this.isShared,
      participants: participants ?? this.participants,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<double>(targetAmount.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<double>(currentAmount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (strategy.present) {
      map['strategy'] = Variable<String>(strategy.value);
    }
    if (autoSaveRules.present) {
      map['auto_save_rules'] = Variable<String>(autoSaveRules.value);
    }
    if (isShared.present) {
      map['is_shared'] = Variable<bool>(isShared.value);
    }
    if (participants.present) {
      map['participants'] = Variable<String>(participants.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('emoji: $emoji, ')
          ..write('type: $type, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('currency: $currency, ')
          ..write('deadline: $deadline, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('strategy: $strategy, ')
          ..write('autoSaveRules: $autoSaveRules, ')
          ..write('isShared: $isShared, ')
          ..write('participants: $participants, ')
          ..write('image: $image, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChallengesTable extends Challenges
    with TableInfo<$ChallengesTable, Challenge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChallengesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
    'target_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentValueMeta = const VerificationMeta(
    'currentValue',
  );
  @override
  late final GeneratedColumn<double> currentValue = GeneratedColumn<double>(
    'current_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
  );
  static const VerificationMeta _durationDaysMeta = const VerificationMeta(
    'durationDays',
  );
  @override
  late final GeneratedColumn<int> durationDays = GeneratedColumn<int>(
    'duration_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _participantsMeta = const VerificationMeta(
    'participants',
  );
  @override
  late final GeneratedColumn<String> participants = GeneratedColumn<String>(
    'participants',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    type,
    targetValue,
    currentValue,
    points,
    startDate,
    endDate,
    difficulty,
    durationDays,
    icon,
    isCompleted,
    participants,
    category,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'challenges';
  @override
  VerificationContext validateIntegrity(
    Insertable<Challenge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    }
    if (data.containsKey('current_value')) {
      context.handle(
        _currentValueMeta,
        currentValue.isAcceptableOrUnknown(
          data['current_value']!,
          _currentValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentValueMeta);
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('duration_days')) {
      context.handle(
        _durationDaysMeta,
        durationDays.isAcceptableOrUnknown(
          data['duration_days']!,
          _durationDaysMeta,
        ),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('participants')) {
      context.handle(
        _participantsMeta,
        participants.isAcceptableOrUnknown(
          data['participants']!,
          _participantsMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Challenge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Challenge(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_value'],
      ),
      currentValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_value'],
      )!,
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      durationDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_days'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      participants: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}participants'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ChallengesTable createAlias(String alias) {
    return $ChallengesTable(attachedDatabase, alias);
  }
}

class Challenge extends DataClass implements Insertable<Challenge> {
  final String id;
  final String title;
  final String description;
  final String type;
  final double? targetValue;
  final double currentValue;
  final int points;
  final DateTime startDate;
  final DateTime endDate;
  final String difficulty;
  final int durationDays;
  final String? icon;
  final bool isCompleted;
  final String participants;
  final String? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.targetValue,
    required this.currentValue,
    required this.points,
    required this.startDate,
    required this.endDate,
    required this.difficulty,
    required this.durationDays,
    this.icon,
    required this.isCompleted,
    required this.participants,
    this.category,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || targetValue != null) {
      map['target_value'] = Variable<double>(targetValue);
    }
    map['current_value'] = Variable<double>(currentValue);
    map['points'] = Variable<int>(points);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['difficulty'] = Variable<String>(difficulty);
    map['duration_days'] = Variable<int>(durationDays);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['participants'] = Variable<String>(participants);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ChallengesCompanion toCompanion(bool nullToAbsent) {
    return ChallengesCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      type: Value(type),
      targetValue: targetValue == null && nullToAbsent
          ? const Value.absent()
          : Value(targetValue),
      currentValue: Value(currentValue),
      points: Value(points),
      startDate: Value(startDate),
      endDate: Value(endDate),
      difficulty: Value(difficulty),
      durationDays: Value(durationDays),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      isCompleted: Value(isCompleted),
      participants: Value(participants),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Challenge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Challenge(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      targetValue: serializer.fromJson<double?>(json['targetValue']),
      currentValue: serializer.fromJson<double>(json['currentValue']),
      points: serializer.fromJson<int>(json['points']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      durationDays: serializer.fromJson<int>(json['durationDays']),
      icon: serializer.fromJson<String?>(json['icon']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      participants: serializer.fromJson<String>(json['participants']),
      category: serializer.fromJson<String?>(json['category']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'type': serializer.toJson<String>(type),
      'targetValue': serializer.toJson<double?>(targetValue),
      'currentValue': serializer.toJson<double>(currentValue),
      'points': serializer.toJson<int>(points),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'difficulty': serializer.toJson<String>(difficulty),
      'durationDays': serializer.toJson<int>(durationDays),
      'icon': serializer.toJson<String?>(icon),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'participants': serializer.toJson<String>(participants),
      'category': serializer.toJson<String?>(category),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    Value<double?> targetValue = const Value.absent(),
    double? currentValue,
    int? points,
    DateTime? startDate,
    DateTime? endDate,
    String? difficulty,
    int? durationDays,
    Value<String?> icon = const Value.absent(),
    bool? isCompleted,
    String? participants,
    Value<String?> category = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Challenge(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    type: type ?? this.type,
    targetValue: targetValue.present ? targetValue.value : this.targetValue,
    currentValue: currentValue ?? this.currentValue,
    points: points ?? this.points,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    difficulty: difficulty ?? this.difficulty,
    durationDays: durationDays ?? this.durationDays,
    icon: icon.present ? icon.value : this.icon,
    isCompleted: isCompleted ?? this.isCompleted,
    participants: participants ?? this.participants,
    category: category.present ? category.value : this.category,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Challenge copyWithCompanion(ChallengesCompanion data) {
    return Challenge(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      type: data.type.present ? data.type.value : this.type,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      points: data.points.present ? data.points.value : this.points,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      durationDays: data.durationDays.present
          ? data.durationDays.value
          : this.durationDays,
      icon: data.icon.present ? data.icon.value : this.icon,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      participants: data.participants.present
          ? data.participants.value
          : this.participants,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Challenge(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('points: $points, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('difficulty: $difficulty, ')
          ..write('durationDays: $durationDays, ')
          ..write('icon: $icon, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('participants: $participants, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    type,
    targetValue,
    currentValue,
    points,
    startDate,
    endDate,
    difficulty,
    durationDays,
    icon,
    isCompleted,
    participants,
    category,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Challenge &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.type == this.type &&
          other.targetValue == this.targetValue &&
          other.currentValue == this.currentValue &&
          other.points == this.points &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.difficulty == this.difficulty &&
          other.durationDays == this.durationDays &&
          other.icon == this.icon &&
          other.isCompleted == this.isCompleted &&
          other.participants == this.participants &&
          other.category == this.category &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ChallengesCompanion extends UpdateCompanion<Challenge> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> type;
  final Value<double?> targetValue;
  final Value<double> currentValue;
  final Value<int> points;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String> difficulty;
  final Value<int> durationDays;
  final Value<String?> icon;
  final Value<bool> isCompleted;
  final Value<String> participants;
  final Value<String?> category;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const ChallengesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.points = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.durationDays = const Value.absent(),
    this.icon = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.participants = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChallengesCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String type,
    this.targetValue = const Value.absent(),
    required double currentValue,
    required int points,
    required DateTime startDate,
    required DateTime endDate,
    this.difficulty = const Value.absent(),
    this.durationDays = const Value.absent(),
    this.icon = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.participants = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       type = Value(type),
       currentValue = Value(currentValue),
       points = Value(points),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<Challenge> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? type,
    Expression<double>? targetValue,
    Expression<double>? currentValue,
    Expression<int>? points,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? difficulty,
    Expression<int>? durationDays,
    Expression<String>? icon,
    Expression<bool>? isCompleted,
    Expression<String>? participants,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (targetValue != null) 'target_value': targetValue,
      if (currentValue != null) 'current_value': currentValue,
      if (points != null) 'points': points,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (difficulty != null) 'difficulty': difficulty,
      if (durationDays != null) 'duration_days': durationDays,
      if (icon != null) 'icon': icon,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (participants != null) 'participants': participants,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChallengesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? type,
    Value<double?>? targetValue,
    Value<double>? currentValue,
    Value<int>? points,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<String>? difficulty,
    Value<int>? durationDays,
    Value<String?>? icon,
    Value<bool>? isCompleted,
    Value<String>? participants,
    Value<String?>? category,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return ChallengesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      points: points ?? this.points,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      difficulty: difficulty ?? this.difficulty,
      durationDays: durationDays ?? this.durationDays,
      icon: icon ?? this.icon,
      isCompleted: isCompleted ?? this.isCompleted,
      participants: participants ?? this.participants,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<double>(currentValue.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (durationDays.present) {
      map['duration_days'] = Variable<int>(durationDays.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (participants.present) {
      map['participants'] = Variable<String>(participants.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChallengesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('points: $points, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('difficulty: $difficulty, ')
          ..write('durationDays: $durationDays, ')
          ..write('icon: $icon, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('participants: $participants, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('sent'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    sender,
    timestamp,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessage extends DataClass implements Insertable<ChatMessage> {
  final String id;
  final String content;
  final String sender;
  final DateTime timestamp;
  final String status;
  const ChatMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<String>(content);
    map['sender'] = Variable<String>(sender);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['status'] = Variable<String>(status);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      content: Value(content),
      sender: Value(sender),
      timestamp: Value(timestamp),
      status: Value(status),
    );
  }

  factory ChatMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessage(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      sender: serializer.fromJson<String>(json['sender']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'sender': serializer.toJson<String>(sender),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'status': serializer.toJson<String>(status),
    };
  }

  ChatMessage copyWith({
    String? id,
    String? content,
    String? sender,
    DateTime? timestamp,
    String? status,
  }) => ChatMessage(
    id: id ?? this.id,
    content: content ?? this.content,
    sender: sender ?? this.sender,
    timestamp: timestamp ?? this.timestamp,
    status: status ?? this.status,
  );
  ChatMessage copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessage(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      sender: data.sender.present ? data.sender.value : this.sender,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessage(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('sender: $sender, ')
          ..write('timestamp: $timestamp, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, sender, timestamp, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          other.id == this.id &&
          other.content == this.content &&
          other.sender == this.sender &&
          other.timestamp == this.timestamp &&
          other.status == this.status);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessage> {
  final Value<String> id;
  final Value<String> content;
  final Value<String> sender;
  final Value<DateTime> timestamp;
  final Value<String> status;
  final Value<int> rowid;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.sender = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    required String id,
    required String content,
    required String sender,
    required DateTime timestamp,
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       content = Value(content),
       sender = Value(sender),
       timestamp = Value(timestamp);
  static Insertable<ChatMessage> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<String>? sender,
    Expression<DateTime>? timestamp,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (sender != null) 'sender': sender,
      if (timestamp != null) 'timestamp': timestamp,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? content,
    Value<String>? sender,
    Value<DateTime>? timestamp,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('sender: $sender, ')
          ..write('timestamp: $timestamp, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvestmentsTable extends Investments
    with TableInfo<$InvestmentsTable, Investment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialAmountMeta = const VerificationMeta(
    'initialAmount',
  );
  @override
  late final GeneratedColumn<double> initialAmount = GeneratedColumn<double>(
    'initial_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentAmountMeta = const VerificationMeta(
    'currentAmount',
  );
  @override
  late final GeneratedColumn<double> currentAmount = GeneratedColumn<double>(
    'current_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('XAF'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _historyMeta = const VerificationMeta(
    'history',
  );
  @override
  late final GeneratedColumn<String> history = GeneratedColumn<String>(
    'history',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    initialAmount,
    currentAmount,
    currency,
    status,
    history,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'investments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Investment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('initial_amount')) {
      context.handle(
        _initialAmountMeta,
        initialAmount.isAcceptableOrUnknown(
          data['initial_amount']!,
          _initialAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initialAmountMeta);
    }
    if (data.containsKey('current_amount')) {
      context.handle(
        _currentAmountMeta,
        currentAmount.isAcceptableOrUnknown(
          data['current_amount']!,
          _currentAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentAmountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('history')) {
      context.handle(
        _historyMeta,
        history.isAcceptableOrUnknown(data['history']!, _historyMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Investment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Investment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      initialAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}initial_amount'],
      )!,
      currentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      history: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}history'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $InvestmentsTable createAlias(String alias) {
    return $InvestmentsTable(attachedDatabase, alias);
  }
}

class Investment extends DataClass implements Insertable<Investment> {
  final String id;
  final String name;
  final String type;
  final double initialAmount;
  final double currentAmount;
  final String currency;
  final String status;
  final String history;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const Investment({
    required this.id,
    required this.name,
    required this.type,
    required this.initialAmount,
    required this.currentAmount,
    required this.currency,
    required this.status,
    required this.history,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['initial_amount'] = Variable<double>(initialAmount);
    map['current_amount'] = Variable<double>(currentAmount);
    map['currency'] = Variable<String>(currency);
    map['status'] = Variable<String>(status);
    map['history'] = Variable<String>(history);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  InvestmentsCompanion toCompanion(bool nullToAbsent) {
    return InvestmentsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      initialAmount: Value(initialAmount),
      currentAmount: Value(currentAmount),
      currency: Value(currency),
      status: Value(status),
      history: Value(history),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Investment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Investment(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      initialAmount: serializer.fromJson<double>(json['initialAmount']),
      currentAmount: serializer.fromJson<double>(json['currentAmount']),
      currency: serializer.fromJson<String>(json['currency']),
      status: serializer.fromJson<String>(json['status']),
      history: serializer.fromJson<String>(json['history']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'initialAmount': serializer.toJson<double>(initialAmount),
      'currentAmount': serializer.toJson<double>(currentAmount),
      'currency': serializer.toJson<String>(currency),
      'status': serializer.toJson<String>(status),
      'history': serializer.toJson<String>(history),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Investment copyWith({
    String? id,
    String? name,
    String? type,
    double? initialAmount,
    double? currentAmount,
    String? currency,
    String? status,
    String? history,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Investment(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    initialAmount: initialAmount ?? this.initialAmount,
    currentAmount: currentAmount ?? this.currentAmount,
    currency: currency ?? this.currency,
    status: status ?? this.status,
    history: history ?? this.history,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Investment copyWithCompanion(InvestmentsCompanion data) {
    return Investment(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      initialAmount: data.initialAmount.present
          ? data.initialAmount.value
          : this.initialAmount,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      currency: data.currency.present ? data.currency.value : this.currency,
      status: data.status.present ? data.status.value : this.status,
      history: data.history.present ? data.history.value : this.history,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Investment(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('initialAmount: $initialAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('currency: $currency, ')
          ..write('status: $status, ')
          ..write('history: $history, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    initialAmount,
    currentAmount,
    currency,
    status,
    history,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Investment &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.initialAmount == this.initialAmount &&
          other.currentAmount == this.currentAmount &&
          other.currency == this.currency &&
          other.status == this.status &&
          other.history == this.history &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InvestmentsCompanion extends UpdateCompanion<Investment> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<double> initialAmount;
  final Value<double> currentAmount;
  final Value<String> currency;
  final Value<String> status;
  final Value<String> history;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const InvestmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.initialAmount = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.status = const Value.absent(),
    this.history = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvestmentsCompanion.insert({
    required String id,
    required String name,
    required String type,
    required double initialAmount,
    required double currentAmount,
    this.currency = const Value.absent(),
    this.status = const Value.absent(),
    this.history = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       initialAmount = Value(initialAmount),
       currentAmount = Value(currentAmount);
  static Insertable<Investment> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? initialAmount,
    Expression<double>? currentAmount,
    Expression<String>? currency,
    Expression<String>? status,
    Expression<String>? history,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (initialAmount != null) 'initial_amount': initialAmount,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (currency != null) 'currency': currency,
      if (status != null) 'status': status,
      if (history != null) 'history': history,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvestmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<double>? initialAmount,
    Value<double>? currentAmount,
    Value<String>? currency,
    Value<String>? status,
    Value<String>? history,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return InvestmentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      initialAmount: initialAmount ?? this.initialAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      history: history ?? this.history,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (initialAmount.present) {
      map['initial_amount'] = Variable<double>(initialAmount.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<double>(currentAmount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (history.present) {
      map['history'] = Variable<String>(history.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('initialAmount: $initialAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('currency: $currency, ')
          ..write('status: $status, ')
          ..write('history: $history, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncRequestsTable extends SyncRequests
    with TableInfo<$SyncRequestsTable, SyncRequest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncRequestsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tableMeta = const VerificationMeta('table');
  @override
  late final GeneratedColumn<String> table = GeneratedColumn<String>(
    'table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, table, action, payload, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_requests';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncRequest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table')) {
      context.handle(
        _tableMeta,
        table.isAcceptableOrUnknown(data['table']!, _tableMeta),
      );
    } else if (isInserting) {
      context.missing(_tableMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncRequest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncRequest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      table: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncRequestsTable createAlias(String alias) {
    return $SyncRequestsTable(attachedDatabase, alias);
  }
}

class SyncRequest extends DataClass implements Insertable<SyncRequest> {
  final int id;
  final String table;
  final String action;
  final String payload;
  final DateTime createdAt;
  const SyncRequest({
    required this.id,
    required this.table,
    required this.action,
    required this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table'] = Variable<String>(table);
    map['action'] = Variable<String>(action);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncRequestsCompanion toCompanion(bool nullToAbsent) {
    return SyncRequestsCompanion(
      id: Value(id),
      table: Value(table),
      action: Value(action),
      payload: Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory SyncRequest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncRequest(
      id: serializer.fromJson<int>(json['id']),
      table: serializer.fromJson<String>(json['table']),
      action: serializer.fromJson<String>(json['action']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'table': serializer.toJson<String>(table),
      'action': serializer.toJson<String>(action),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncRequest copyWith({
    int? id,
    String? table,
    String? action,
    String? payload,
    DateTime? createdAt,
  }) => SyncRequest(
    id: id ?? this.id,
    table: table ?? this.table,
    action: action ?? this.action,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncRequest copyWithCompanion(SyncRequestsCompanion data) {
    return SyncRequest(
      id: data.id.present ? data.id.value : this.id,
      table: data.table.present ? data.table.value : this.table,
      action: data.action.present ? data.action.value : this.action,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncRequest(')
          ..write('id: $id, ')
          ..write('table: $table, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, table, action, payload, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncRequest &&
          other.id == this.id &&
          other.table == this.table &&
          other.action == this.action &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class SyncRequestsCompanion extends UpdateCompanion<SyncRequest> {
  final Value<int> id;
  final Value<String> table;
  final Value<String> action;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  const SyncRequestsCompanion({
    this.id = const Value.absent(),
    this.table = const Value.absent(),
    this.action = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncRequestsCompanion.insert({
    this.id = const Value.absent(),
    required String table,
    required String action,
    required String payload,
    this.createdAt = const Value.absent(),
  }) : table = Value(table),
       action = Value(action),
       payload = Value(payload);
  static Insertable<SyncRequest> custom({
    Expression<int>? id,
    Expression<String>? table,
    Expression<String>? action,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (table != null) 'table': table,
      if (action != null) 'action': action,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncRequestsCompanion copyWith({
    Value<int>? id,
    Value<String>? table,
    Value<String>? action,
    Value<String>? payload,
    Value<DateTime>? createdAt,
  }) {
    return SyncRequestsCompanion(
      id: id ?? this.id,
      table: table ?? this.table,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (table.present) {
      map['table'] = Variable<String>(table.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncRequestsCompanion(')
          ..write('id: $id, ')
          ..write('table: $table, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserSubscriptionsTable extends UserSubscriptions
    with TableInfo<$UserSubscriptionsTable, UserSubscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('XAF'),
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _nextBillingDateMeta = const VerificationMeta(
    'nextBillingDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextBillingDate =
      GeneratedColumn<DateTime>(
        'next_billing_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _trialEndDateMeta = const VerificationMeta(
    'trialEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> trialEndDate = GeneratedColumn<DateTime>(
    'trial_end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindMeMeta = const VerificationMeta(
    'remindMe',
  );
  @override
  late final GeneratedColumn<bool> remindMe = GeneratedColumn<bool>(
    'remind_me',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("remind_me" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    provider,
    amount,
    currency,
    frequency,
    category,
    status,
    nextBillingDate,
    trialEndDate,
    remindMe,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSubscription> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('next_billing_date')) {
      context.handle(
        _nextBillingDateMeta,
        nextBillingDate.isAcceptableOrUnknown(
          data['next_billing_date']!,
          _nextBillingDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextBillingDateMeta);
    }
    if (data.containsKey('trial_end_date')) {
      context.handle(
        _trialEndDateMeta,
        trialEndDate.isAcceptableOrUnknown(
          data['trial_end_date']!,
          _trialEndDateMeta,
        ),
      );
    }
    if (data.containsKey('remind_me')) {
      context.handle(
        _remindMeMeta,
        remindMe.isAcceptableOrUnknown(data['remind_me']!, _remindMeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSubscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSubscription(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      nextBillingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_billing_date'],
      )!,
      trialEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}trial_end_date'],
      ),
      remindMe: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}remind_me'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $UserSubscriptionsTable createAlias(String alias) {
    return $UserSubscriptionsTable(attachedDatabase, alias);
  }
}

class UserSubscription extends DataClass
    implements Insertable<UserSubscription> {
  final String id;
  final String name;
  final String? provider;
  final double amount;
  final String currency;
  final String frequency;
  final String? category;
  final String status;
  final DateTime nextBillingDate;
  final DateTime? trialEndDate;
  final bool remindMe;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const UserSubscription({
    required this.id,
    required this.name,
    this.provider,
    required this.amount,
    required this.currency,
    required this.frequency,
    this.category,
    required this.status,
    required this.nextBillingDate,
    this.trialEndDate,
    required this.remindMe,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || provider != null) {
      map['provider'] = Variable<String>(provider);
    }
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['frequency'] = Variable<String>(frequency);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['status'] = Variable<String>(status);
    map['next_billing_date'] = Variable<DateTime>(nextBillingDate);
    if (!nullToAbsent || trialEndDate != null) {
      map['trial_end_date'] = Variable<DateTime>(trialEndDate);
    }
    map['remind_me'] = Variable<bool>(remindMe);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  UserSubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return UserSubscriptionsCompanion(
      id: Value(id),
      name: Value(name),
      provider: provider == null && nullToAbsent
          ? const Value.absent()
          : Value(provider),
      amount: Value(amount),
      currency: Value(currency),
      frequency: Value(frequency),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      status: Value(status),
      nextBillingDate: Value(nextBillingDate),
      trialEndDate: trialEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(trialEndDate),
      remindMe: Value(remindMe),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory UserSubscription.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSubscription(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      provider: serializer.fromJson<String?>(json['provider']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      frequency: serializer.fromJson<String>(json['frequency']),
      category: serializer.fromJson<String?>(json['category']),
      status: serializer.fromJson<String>(json['status']),
      nextBillingDate: serializer.fromJson<DateTime>(json['nextBillingDate']),
      trialEndDate: serializer.fromJson<DateTime?>(json['trialEndDate']),
      remindMe: serializer.fromJson<bool>(json['remindMe']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'provider': serializer.toJson<String?>(provider),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'frequency': serializer.toJson<String>(frequency),
      'category': serializer.toJson<String?>(category),
      'status': serializer.toJson<String>(status),
      'nextBillingDate': serializer.toJson<DateTime>(nextBillingDate),
      'trialEndDate': serializer.toJson<DateTime?>(trialEndDate),
      'remindMe': serializer.toJson<bool>(remindMe),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  UserSubscription copyWith({
    String? id,
    String? name,
    Value<String?> provider = const Value.absent(),
    double? amount,
    String? currency,
    String? frequency,
    Value<String?> category = const Value.absent(),
    String? status,
    DateTime? nextBillingDate,
    Value<DateTime?> trialEndDate = const Value.absent(),
    bool? remindMe,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => UserSubscription(
    id: id ?? this.id,
    name: name ?? this.name,
    provider: provider.present ? provider.value : this.provider,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    frequency: frequency ?? this.frequency,
    category: category.present ? category.value : this.category,
    status: status ?? this.status,
    nextBillingDate: nextBillingDate ?? this.nextBillingDate,
    trialEndDate: trialEndDate.present ? trialEndDate.value : this.trialEndDate,
    remindMe: remindMe ?? this.remindMe,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  UserSubscription copyWithCompanion(UserSubscriptionsCompanion data) {
    return UserSubscription(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      provider: data.provider.present ? data.provider.value : this.provider,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      category: data.category.present ? data.category.value : this.category,
      status: data.status.present ? data.status.value : this.status,
      nextBillingDate: data.nextBillingDate.present
          ? data.nextBillingDate.value
          : this.nextBillingDate,
      trialEndDate: data.trialEndDate.present
          ? data.trialEndDate.value
          : this.trialEndDate,
      remindMe: data.remindMe.present ? data.remindMe.value : this.remindMe,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSubscription(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('provider: $provider, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('frequency: $frequency, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('nextBillingDate: $nextBillingDate, ')
          ..write('trialEndDate: $trialEndDate, ')
          ..write('remindMe: $remindMe, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    provider,
    amount,
    currency,
    frequency,
    category,
    status,
    nextBillingDate,
    trialEndDate,
    remindMe,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSubscription &&
          other.id == this.id &&
          other.name == this.name &&
          other.provider == this.provider &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.frequency == this.frequency &&
          other.category == this.category &&
          other.status == this.status &&
          other.nextBillingDate == this.nextBillingDate &&
          other.trialEndDate == this.trialEndDate &&
          other.remindMe == this.remindMe &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserSubscriptionsCompanion extends UpdateCompanion<UserSubscription> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> provider;
  final Value<double> amount;
  final Value<String> currency;
  final Value<String> frequency;
  final Value<String?> category;
  final Value<String> status;
  final Value<DateTime> nextBillingDate;
  final Value<DateTime?> trialEndDate;
  final Value<bool> remindMe;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const UserSubscriptionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.provider = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.frequency = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
    this.nextBillingDate = const Value.absent(),
    this.trialEndDate = const Value.absent(),
    this.remindMe = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSubscriptionsCompanion.insert({
    required String id,
    required String name,
    this.provider = const Value.absent(),
    required double amount,
    this.currency = const Value.absent(),
    required String frequency,
    this.category = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime nextBillingDate,
    this.trialEndDate = const Value.absent(),
    this.remindMe = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       amount = Value(amount),
       frequency = Value(frequency),
       nextBillingDate = Value(nextBillingDate);
  static Insertable<UserSubscription> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? provider,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<String>? frequency,
    Expression<String>? category,
    Expression<String>? status,
    Expression<DateTime>? nextBillingDate,
    Expression<DateTime>? trialEndDate,
    Expression<bool>? remindMe,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (provider != null) 'provider': provider,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (frequency != null) 'frequency': frequency,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
      if (nextBillingDate != null) 'next_billing_date': nextBillingDate,
      if (trialEndDate != null) 'trial_end_date': trialEndDate,
      if (remindMe != null) 'remind_me': remindMe,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSubscriptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? provider,
    Value<double>? amount,
    Value<String>? currency,
    Value<String>? frequency,
    Value<String?>? category,
    Value<String>? status,
    Value<DateTime>? nextBillingDate,
    Value<DateTime?>? trialEndDate,
    Value<bool>? remindMe,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserSubscriptionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      provider: provider ?? this.provider,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      frequency: frequency ?? this.frequency,
      category: category ?? this.category,
      status: status ?? this.status,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      remindMe: remindMe ?? this.remindMe,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (nextBillingDate.present) {
      map['next_billing_date'] = Variable<DateTime>(nextBillingDate.value);
    }
    if (trialEndDate.present) {
      map['trial_end_date'] = Variable<DateTime>(trialEndDate.value);
    }
    if (remindMe.present) {
      map['remind_me'] = Variable<bool>(remindMe.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('provider: $provider, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('frequency: $frequency, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('nextBillingDate: $nextBillingDate, ')
          ..write('trialEndDate: $trialEndDate, ')
          ..write('remindMe: $remindMe, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserChallengesTable extends UserChallenges
    with TableInfo<$UserChallengesTable, UserChallenge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserChallengesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _currentValueMeta = const VerificationMeta(
    'currentValue',
  );
  @override
  late final GeneratedColumn<double> currentValue = GeneratedColumn<double>(
    'current_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _challengeDataMeta = const VerificationMeta(
    'challengeData',
  );
  @override
  late final GeneratedColumn<String> challengeData = GeneratedColumn<String>(
    'challenge_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weeksMeta = const VerificationMeta('weeks');
  @override
  late final GeneratedColumn<String> weeks = GeneratedColumn<String>(
    'weeks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    status,
    progress,
    currentValue,
    challengeData,
    weeks,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_challenges';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserChallenge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('current_value')) {
      context.handle(
        _currentValueMeta,
        currentValue.isAcceptableOrUnknown(
          data['current_value']!,
          _currentValueMeta,
        ),
      );
    }
    if (data.containsKey('challenge_data')) {
      context.handle(
        _challengeDataMeta,
        challengeData.isAcceptableOrUnknown(
          data['challenge_data']!,
          _challengeDataMeta,
        ),
      );
    }
    if (data.containsKey('weeks')) {
      context.handle(
        _weeksMeta,
        weeks.isAcceptableOrUnknown(data['weeks']!, _weeksMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserChallenge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserChallenge(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress'],
      )!,
      currentValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_value'],
      )!,
      challengeData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}challenge_data'],
      ),
      weeks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weeks'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $UserChallengesTable createAlias(String alias) {
    return $UserChallengesTable(attachedDatabase, alias);
  }
}

class UserChallenge extends DataClass implements Insertable<UserChallenge> {
  final String id;
  final String status;
  final double progress;
  final double currentValue;
  final String? challengeData;
  final String? weeks;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const UserChallenge({
    required this.id,
    required this.status,
    required this.progress,
    required this.currentValue,
    this.challengeData,
    this.weeks,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['status'] = Variable<String>(status);
    map['progress'] = Variable<double>(progress);
    map['current_value'] = Variable<double>(currentValue);
    if (!nullToAbsent || challengeData != null) {
      map['challenge_data'] = Variable<String>(challengeData);
    }
    if (!nullToAbsent || weeks != null) {
      map['weeks'] = Variable<String>(weeks);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  UserChallengesCompanion toCompanion(bool nullToAbsent) {
    return UserChallengesCompanion(
      id: Value(id),
      status: Value(status),
      progress: Value(progress),
      currentValue: Value(currentValue),
      challengeData: challengeData == null && nullToAbsent
          ? const Value.absent()
          : Value(challengeData),
      weeks: weeks == null && nullToAbsent
          ? const Value.absent()
          : Value(weeks),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory UserChallenge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserChallenge(
      id: serializer.fromJson<String>(json['id']),
      status: serializer.fromJson<String>(json['status']),
      progress: serializer.fromJson<double>(json['progress']),
      currentValue: serializer.fromJson<double>(json['currentValue']),
      challengeData: serializer.fromJson<String?>(json['challengeData']),
      weeks: serializer.fromJson<String?>(json['weeks']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'status': serializer.toJson<String>(status),
      'progress': serializer.toJson<double>(progress),
      'currentValue': serializer.toJson<double>(currentValue),
      'challengeData': serializer.toJson<String?>(challengeData),
      'weeks': serializer.toJson<String?>(weeks),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  UserChallenge copyWith({
    String? id,
    String? status,
    double? progress,
    double? currentValue,
    Value<String?> challengeData = const Value.absent(),
    Value<String?> weeks = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => UserChallenge(
    id: id ?? this.id,
    status: status ?? this.status,
    progress: progress ?? this.progress,
    currentValue: currentValue ?? this.currentValue,
    challengeData: challengeData.present
        ? challengeData.value
        : this.challengeData,
    weeks: weeks.present ? weeks.value : this.weeks,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  UserChallenge copyWithCompanion(UserChallengesCompanion data) {
    return UserChallenge(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
      progress: data.progress.present ? data.progress.value : this.progress,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      challengeData: data.challengeData.present
          ? data.challengeData.value
          : this.challengeData,
      weeks: data.weeks.present ? data.weeks.value : this.weeks,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserChallenge(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('progress: $progress, ')
          ..write('currentValue: $currentValue, ')
          ..write('challengeData: $challengeData, ')
          ..write('weeks: $weeks, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    status,
    progress,
    currentValue,
    challengeData,
    weeks,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserChallenge &&
          other.id == this.id &&
          other.status == this.status &&
          other.progress == this.progress &&
          other.currentValue == this.currentValue &&
          other.challengeData == this.challengeData &&
          other.weeks == this.weeks &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserChallengesCompanion extends UpdateCompanion<UserChallenge> {
  final Value<String> id;
  final Value<String> status;
  final Value<double> progress;
  final Value<double> currentValue;
  final Value<String?> challengeData;
  final Value<String?> weeks;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const UserChallengesCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.progress = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.challengeData = const Value.absent(),
    this.weeks = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserChallengesCompanion.insert({
    required String id,
    this.status = const Value.absent(),
    this.progress = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.challengeData = const Value.absent(),
    this.weeks = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<UserChallenge> custom({
    Expression<String>? id,
    Expression<String>? status,
    Expression<double>? progress,
    Expression<double>? currentValue,
    Expression<String>? challengeData,
    Expression<String>? weeks,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (progress != null) 'progress': progress,
      if (currentValue != null) 'current_value': currentValue,
      if (challengeData != null) 'challenge_data': challengeData,
      if (weeks != null) 'weeks': weeks,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserChallengesCompanion copyWith({
    Value<String>? id,
    Value<String>? status,
    Value<double>? progress,
    Value<double>? currentValue,
    Value<String?>? challengeData,
    Value<String?>? weeks,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserChallengesCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      currentValue: currentValue ?? this.currentValue,
      challengeData: challengeData ?? this.challengeData,
      weeks: weeks ?? this.weeks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<double>(currentValue.value);
    }
    if (challengeData.present) {
      map['challenge_data'] = Variable<String>(challengeData.value);
    }
    if (weeks.present) {
      map['weeks'] = Variable<String>(weeks.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserChallengesCompanion(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('progress: $progress, ')
          ..write('currentValue: $currentValue, ')
          ..write('challengeData: $challengeData, ')
          ..write('weeks: $weeks, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TontinesTable extends Tontines with TableInfo<$TontinesTable, Tontine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TontinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contributionAmountMeta =
      const VerificationMeta('contributionAmount');
  @override
  late final GeneratedColumn<double> contributionAmount =
      GeneratedColumn<double>(
        'contribution_amount',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _totalPartsMeta = const VerificationMeta(
    'totalParts',
  );
  @override
  late final GeneratedColumn<int> totalParts = GeneratedColumn<int>(
    'total_parts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('XAF'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _creatorIdMeta = const VerificationMeta(
    'creatorId',
  );
  @override
  late final GeneratedColumn<String> creatorId = GeneratedColumn<String>(
    'creator_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inviteCodeMeta = const VerificationMeta(
    'inviteCode',
  );
  @override
  late final GeneratedColumn<String> inviteCode = GeneratedColumn<String>(
    'invite_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentTurnMeta = const VerificationMeta(
    'currentTurn',
  );
  @override
  late final GeneratedColumn<int> currentTurn = GeneratedColumn<int>(
    'current_turn',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rotationModeMeta = const VerificationMeta(
    'rotationMode',
  );
  @override
  late final GeneratedColumn<String> rotationMode = GeneratedColumn<String>(
    'rotation_mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validationModeMeta = const VerificationMeta(
    'validationMode',
  );
  @override
  late final GeneratedColumn<String> validationMode = GeneratedColumn<String>(
    'validation_mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sanctionsMeta = const VerificationMeta(
    'sanctions',
  );
  @override
  late final GeneratedColumn<String> sanctions = GeneratedColumn<String>(
    'sanctions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _socialFundMeta = const VerificationMeta(
    'socialFund',
  );
  @override
  late final GeneratedColumn<String> socialFund = GeneratedColumn<String>(
    'social_fund',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _escrowDetailsMeta = const VerificationMeta(
    'escrowDetails',
  );
  @override
  late final GeneratedColumn<String> escrowDetails = GeneratedColumn<String>(
    'escrow_details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _autoRenewMeta = const VerificationMeta(
    'autoRenew',
  );
  @override
  late final GeneratedColumn<bool> autoRenew = GeneratedColumn<bool>(
    'auto_renew',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_renew" IN (0, 1))',
    ),
  );
  static const VerificationMeta _rulesAcceptedByAllMeta =
      const VerificationMeta('rulesAcceptedByAll');
  @override
  late final GeneratedColumn<bool> rulesAcceptedByAll = GeneratedColumn<bool>(
    'rules_accepted_by_all',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("rules_accepted_by_all" IN (0, 1))',
    ),
  );
  static const VerificationMeta _extraDataMeta = const VerificationMeta(
    'extraData',
  );
  @override
  late final GeneratedColumn<String> extraData = GeneratedColumn<String>(
    'extra_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    frequency,
    contributionAmount,
    totalParts,
    currency,
    status,
    creatorId,
    inviteCode,
    currentTurn,
    startDate,
    createdAt,
    updatedAt,
    rotationMode,
    validationMode,
    sanctions,
    socialFund,
    escrowDetails,
    autoRenew,
    rulesAcceptedByAll,
    extraData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tontines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tontine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('contribution_amount')) {
      context.handle(
        _contributionAmountMeta,
        contributionAmount.isAcceptableOrUnknown(
          data['contribution_amount']!,
          _contributionAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contributionAmountMeta);
    }
    if (data.containsKey('total_parts')) {
      context.handle(
        _totalPartsMeta,
        totalParts.isAcceptableOrUnknown(data['total_parts']!, _totalPartsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalPartsMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('creator_id')) {
      context.handle(
        _creatorIdMeta,
        creatorId.isAcceptableOrUnknown(data['creator_id']!, _creatorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creatorIdMeta);
    }
    if (data.containsKey('invite_code')) {
      context.handle(
        _inviteCodeMeta,
        inviteCode.isAcceptableOrUnknown(data['invite_code']!, _inviteCodeMeta),
      );
    }
    if (data.containsKey('current_turn')) {
      context.handle(
        _currentTurnMeta,
        currentTurn.isAcceptableOrUnknown(
          data['current_turn']!,
          _currentTurnMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('rotation_mode')) {
      context.handle(
        _rotationModeMeta,
        rotationMode.isAcceptableOrUnknown(
          data['rotation_mode']!,
          _rotationModeMeta,
        ),
      );
    }
    if (data.containsKey('validation_mode')) {
      context.handle(
        _validationModeMeta,
        validationMode.isAcceptableOrUnknown(
          data['validation_mode']!,
          _validationModeMeta,
        ),
      );
    }
    if (data.containsKey('sanctions')) {
      context.handle(
        _sanctionsMeta,
        sanctions.isAcceptableOrUnknown(data['sanctions']!, _sanctionsMeta),
      );
    }
    if (data.containsKey('social_fund')) {
      context.handle(
        _socialFundMeta,
        socialFund.isAcceptableOrUnknown(data['social_fund']!, _socialFundMeta),
      );
    }
    if (data.containsKey('escrow_details')) {
      context.handle(
        _escrowDetailsMeta,
        escrowDetails.isAcceptableOrUnknown(
          data['escrow_details']!,
          _escrowDetailsMeta,
        ),
      );
    }
    if (data.containsKey('auto_renew')) {
      context.handle(
        _autoRenewMeta,
        autoRenew.isAcceptableOrUnknown(data['auto_renew']!, _autoRenewMeta),
      );
    }
    if (data.containsKey('rules_accepted_by_all')) {
      context.handle(
        _rulesAcceptedByAllMeta,
        rulesAcceptedByAll.isAcceptableOrUnknown(
          data['rules_accepted_by_all']!,
          _rulesAcceptedByAllMeta,
        ),
      );
    }
    if (data.containsKey('extra_data')) {
      context.handle(
        _extraDataMeta,
        extraData.isAcceptableOrUnknown(data['extra_data']!, _extraDataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tontine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tontine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      contributionAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}contribution_amount'],
      )!,
      totalParts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_parts'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      creatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator_id'],
      )!,
      inviteCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invite_code'],
      ),
      currentTurn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_turn'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      rotationMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rotation_mode'],
      ),
      validationMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}validation_mode'],
      ),
      sanctions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sanctions'],
      ),
      socialFund: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}social_fund'],
      ),
      escrowDetails: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}escrow_details'],
      ),
      autoRenew: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_renew'],
      ),
      rulesAcceptedByAll: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}rules_accepted_by_all'],
      ),
      extraData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extra_data'],
      ),
    );
  }

  @override
  $TontinesTable createAlias(String alias) {
    return $TontinesTable(attachedDatabase, alias);
  }
}

class Tontine extends DataClass implements Insertable<Tontine> {
  final String id;
  final String name;
  final String frequency;
  final double contributionAmount;
  final int totalParts;
  final String currency;
  final String status;
  final String creatorId;
  final String? inviteCode;
  final int currentTurn;
  final DateTime? startDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? rotationMode;
  final String? validationMode;
  final String? sanctions;
  final String? socialFund;
  final String? escrowDetails;
  final bool? autoRenew;
  final bool? rulesAcceptedByAll;
  final String? extraData;
  const Tontine({
    required this.id,
    required this.name,
    required this.frequency,
    required this.contributionAmount,
    required this.totalParts,
    required this.currency,
    required this.status,
    required this.creatorId,
    this.inviteCode,
    required this.currentTurn,
    this.startDate,
    this.createdAt,
    this.updatedAt,
    this.rotationMode,
    this.validationMode,
    this.sanctions,
    this.socialFund,
    this.escrowDetails,
    this.autoRenew,
    this.rulesAcceptedByAll,
    this.extraData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['frequency'] = Variable<String>(frequency);
    map['contribution_amount'] = Variable<double>(contributionAmount);
    map['total_parts'] = Variable<int>(totalParts);
    map['currency'] = Variable<String>(currency);
    map['status'] = Variable<String>(status);
    map['creator_id'] = Variable<String>(creatorId);
    if (!nullToAbsent || inviteCode != null) {
      map['invite_code'] = Variable<String>(inviteCode);
    }
    map['current_turn'] = Variable<int>(currentTurn);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || rotationMode != null) {
      map['rotation_mode'] = Variable<String>(rotationMode);
    }
    if (!nullToAbsent || validationMode != null) {
      map['validation_mode'] = Variable<String>(validationMode);
    }
    if (!nullToAbsent || sanctions != null) {
      map['sanctions'] = Variable<String>(sanctions);
    }
    if (!nullToAbsent || socialFund != null) {
      map['social_fund'] = Variable<String>(socialFund);
    }
    if (!nullToAbsent || escrowDetails != null) {
      map['escrow_details'] = Variable<String>(escrowDetails);
    }
    if (!nullToAbsent || autoRenew != null) {
      map['auto_renew'] = Variable<bool>(autoRenew);
    }
    if (!nullToAbsent || rulesAcceptedByAll != null) {
      map['rules_accepted_by_all'] = Variable<bool>(rulesAcceptedByAll);
    }
    if (!nullToAbsent || extraData != null) {
      map['extra_data'] = Variable<String>(extraData);
    }
    return map;
  }

  TontinesCompanion toCompanion(bool nullToAbsent) {
    return TontinesCompanion(
      id: Value(id),
      name: Value(name),
      frequency: Value(frequency),
      contributionAmount: Value(contributionAmount),
      totalParts: Value(totalParts),
      currency: Value(currency),
      status: Value(status),
      creatorId: Value(creatorId),
      inviteCode: inviteCode == null && nullToAbsent
          ? const Value.absent()
          : Value(inviteCode),
      currentTurn: Value(currentTurn),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      rotationMode: rotationMode == null && nullToAbsent
          ? const Value.absent()
          : Value(rotationMode),
      validationMode: validationMode == null && nullToAbsent
          ? const Value.absent()
          : Value(validationMode),
      sanctions: sanctions == null && nullToAbsent
          ? const Value.absent()
          : Value(sanctions),
      socialFund: socialFund == null && nullToAbsent
          ? const Value.absent()
          : Value(socialFund),
      escrowDetails: escrowDetails == null && nullToAbsent
          ? const Value.absent()
          : Value(escrowDetails),
      autoRenew: autoRenew == null && nullToAbsent
          ? const Value.absent()
          : Value(autoRenew),
      rulesAcceptedByAll: rulesAcceptedByAll == null && nullToAbsent
          ? const Value.absent()
          : Value(rulesAcceptedByAll),
      extraData: extraData == null && nullToAbsent
          ? const Value.absent()
          : Value(extraData),
    );
  }

  factory Tontine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tontine(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      frequency: serializer.fromJson<String>(json['frequency']),
      contributionAmount: serializer.fromJson<double>(
        json['contributionAmount'],
      ),
      totalParts: serializer.fromJson<int>(json['totalParts']),
      currency: serializer.fromJson<String>(json['currency']),
      status: serializer.fromJson<String>(json['status']),
      creatorId: serializer.fromJson<String>(json['creatorId']),
      inviteCode: serializer.fromJson<String?>(json['inviteCode']),
      currentTurn: serializer.fromJson<int>(json['currentTurn']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      rotationMode: serializer.fromJson<String?>(json['rotationMode']),
      validationMode: serializer.fromJson<String?>(json['validationMode']),
      sanctions: serializer.fromJson<String?>(json['sanctions']),
      socialFund: serializer.fromJson<String?>(json['socialFund']),
      escrowDetails: serializer.fromJson<String?>(json['escrowDetails']),
      autoRenew: serializer.fromJson<bool?>(json['autoRenew']),
      rulesAcceptedByAll: serializer.fromJson<bool?>(
        json['rulesAcceptedByAll'],
      ),
      extraData: serializer.fromJson<String?>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'frequency': serializer.toJson<String>(frequency),
      'contributionAmount': serializer.toJson<double>(contributionAmount),
      'totalParts': serializer.toJson<int>(totalParts),
      'currency': serializer.toJson<String>(currency),
      'status': serializer.toJson<String>(status),
      'creatorId': serializer.toJson<String>(creatorId),
      'inviteCode': serializer.toJson<String?>(inviteCode),
      'currentTurn': serializer.toJson<int>(currentTurn),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'rotationMode': serializer.toJson<String?>(rotationMode),
      'validationMode': serializer.toJson<String?>(validationMode),
      'sanctions': serializer.toJson<String?>(sanctions),
      'socialFund': serializer.toJson<String?>(socialFund),
      'escrowDetails': serializer.toJson<String?>(escrowDetails),
      'autoRenew': serializer.toJson<bool?>(autoRenew),
      'rulesAcceptedByAll': serializer.toJson<bool?>(rulesAcceptedByAll),
      'extraData': serializer.toJson<String?>(extraData),
    };
  }

  Tontine copyWith({
    String? id,
    String? name,
    String? frequency,
    double? contributionAmount,
    int? totalParts,
    String? currency,
    String? status,
    String? creatorId,
    Value<String?> inviteCode = const Value.absent(),
    int? currentTurn,
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<String?> rotationMode = const Value.absent(),
    Value<String?> validationMode = const Value.absent(),
    Value<String?> sanctions = const Value.absent(),
    Value<String?> socialFund = const Value.absent(),
    Value<String?> escrowDetails = const Value.absent(),
    Value<bool?> autoRenew = const Value.absent(),
    Value<bool?> rulesAcceptedByAll = const Value.absent(),
    Value<String?> extraData = const Value.absent(),
  }) => Tontine(
    id: id ?? this.id,
    name: name ?? this.name,
    frequency: frequency ?? this.frequency,
    contributionAmount: contributionAmount ?? this.contributionAmount,
    totalParts: totalParts ?? this.totalParts,
    currency: currency ?? this.currency,
    status: status ?? this.status,
    creatorId: creatorId ?? this.creatorId,
    inviteCode: inviteCode.present ? inviteCode.value : this.inviteCode,
    currentTurn: currentTurn ?? this.currentTurn,
    startDate: startDate.present ? startDate.value : this.startDate,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    rotationMode: rotationMode.present ? rotationMode.value : this.rotationMode,
    validationMode: validationMode.present
        ? validationMode.value
        : this.validationMode,
    sanctions: sanctions.present ? sanctions.value : this.sanctions,
    socialFund: socialFund.present ? socialFund.value : this.socialFund,
    escrowDetails: escrowDetails.present
        ? escrowDetails.value
        : this.escrowDetails,
    autoRenew: autoRenew.present ? autoRenew.value : this.autoRenew,
    rulesAcceptedByAll: rulesAcceptedByAll.present
        ? rulesAcceptedByAll.value
        : this.rulesAcceptedByAll,
    extraData: extraData.present ? extraData.value : this.extraData,
  );
  Tontine copyWithCompanion(TontinesCompanion data) {
    return Tontine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      contributionAmount: data.contributionAmount.present
          ? data.contributionAmount.value
          : this.contributionAmount,
      totalParts: data.totalParts.present
          ? data.totalParts.value
          : this.totalParts,
      currency: data.currency.present ? data.currency.value : this.currency,
      status: data.status.present ? data.status.value : this.status,
      creatorId: data.creatorId.present ? data.creatorId.value : this.creatorId,
      inviteCode: data.inviteCode.present
          ? data.inviteCode.value
          : this.inviteCode,
      currentTurn: data.currentTurn.present
          ? data.currentTurn.value
          : this.currentTurn,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      rotationMode: data.rotationMode.present
          ? data.rotationMode.value
          : this.rotationMode,
      validationMode: data.validationMode.present
          ? data.validationMode.value
          : this.validationMode,
      sanctions: data.sanctions.present ? data.sanctions.value : this.sanctions,
      socialFund: data.socialFund.present
          ? data.socialFund.value
          : this.socialFund,
      escrowDetails: data.escrowDetails.present
          ? data.escrowDetails.value
          : this.escrowDetails,
      autoRenew: data.autoRenew.present ? data.autoRenew.value : this.autoRenew,
      rulesAcceptedByAll: data.rulesAcceptedByAll.present
          ? data.rulesAcceptedByAll.value
          : this.rulesAcceptedByAll,
      extraData: data.extraData.present ? data.extraData.value : this.extraData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tontine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('frequency: $frequency, ')
          ..write('contributionAmount: $contributionAmount, ')
          ..write('totalParts: $totalParts, ')
          ..write('currency: $currency, ')
          ..write('status: $status, ')
          ..write('creatorId: $creatorId, ')
          ..write('inviteCode: $inviteCode, ')
          ..write('currentTurn: $currentTurn, ')
          ..write('startDate: $startDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rotationMode: $rotationMode, ')
          ..write('validationMode: $validationMode, ')
          ..write('sanctions: $sanctions, ')
          ..write('socialFund: $socialFund, ')
          ..write('escrowDetails: $escrowDetails, ')
          ..write('autoRenew: $autoRenew, ')
          ..write('rulesAcceptedByAll: $rulesAcceptedByAll, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    frequency,
    contributionAmount,
    totalParts,
    currency,
    status,
    creatorId,
    inviteCode,
    currentTurn,
    startDate,
    createdAt,
    updatedAt,
    rotationMode,
    validationMode,
    sanctions,
    socialFund,
    escrowDetails,
    autoRenew,
    rulesAcceptedByAll,
    extraData,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tontine &&
          other.id == this.id &&
          other.name == this.name &&
          other.frequency == this.frequency &&
          other.contributionAmount == this.contributionAmount &&
          other.totalParts == this.totalParts &&
          other.currency == this.currency &&
          other.status == this.status &&
          other.creatorId == this.creatorId &&
          other.inviteCode == this.inviteCode &&
          other.currentTurn == this.currentTurn &&
          other.startDate == this.startDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.rotationMode == this.rotationMode &&
          other.validationMode == this.validationMode &&
          other.sanctions == this.sanctions &&
          other.socialFund == this.socialFund &&
          other.escrowDetails == this.escrowDetails &&
          other.autoRenew == this.autoRenew &&
          other.rulesAcceptedByAll == this.rulesAcceptedByAll &&
          other.extraData == this.extraData);
}

class TontinesCompanion extends UpdateCompanion<Tontine> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> frequency;
  final Value<double> contributionAmount;
  final Value<int> totalParts;
  final Value<String> currency;
  final Value<String> status;
  final Value<String> creatorId;
  final Value<String?> inviteCode;
  final Value<int> currentTurn;
  final Value<DateTime?> startDate;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String?> rotationMode;
  final Value<String?> validationMode;
  final Value<String?> sanctions;
  final Value<String?> socialFund;
  final Value<String?> escrowDetails;
  final Value<bool?> autoRenew;
  final Value<bool?> rulesAcceptedByAll;
  final Value<String?> extraData;
  final Value<int> rowid;
  const TontinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.frequency = const Value.absent(),
    this.contributionAmount = const Value.absent(),
    this.totalParts = const Value.absent(),
    this.currency = const Value.absent(),
    this.status = const Value.absent(),
    this.creatorId = const Value.absent(),
    this.inviteCode = const Value.absent(),
    this.currentTurn = const Value.absent(),
    this.startDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rotationMode = const Value.absent(),
    this.validationMode = const Value.absent(),
    this.sanctions = const Value.absent(),
    this.socialFund = const Value.absent(),
    this.escrowDetails = const Value.absent(),
    this.autoRenew = const Value.absent(),
    this.rulesAcceptedByAll = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TontinesCompanion.insert({
    required String id,
    required String name,
    required String frequency,
    required double contributionAmount,
    required int totalParts,
    this.currency = const Value.absent(),
    this.status = const Value.absent(),
    required String creatorId,
    this.inviteCode = const Value.absent(),
    this.currentTurn = const Value.absent(),
    this.startDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rotationMode = const Value.absent(),
    this.validationMode = const Value.absent(),
    this.sanctions = const Value.absent(),
    this.socialFund = const Value.absent(),
    this.escrowDetails = const Value.absent(),
    this.autoRenew = const Value.absent(),
    this.rulesAcceptedByAll = const Value.absent(),
    this.extraData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       frequency = Value(frequency),
       contributionAmount = Value(contributionAmount),
       totalParts = Value(totalParts),
       creatorId = Value(creatorId);
  static Insertable<Tontine> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? frequency,
    Expression<double>? contributionAmount,
    Expression<int>? totalParts,
    Expression<String>? currency,
    Expression<String>? status,
    Expression<String>? creatorId,
    Expression<String>? inviteCode,
    Expression<int>? currentTurn,
    Expression<DateTime>? startDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? rotationMode,
    Expression<String>? validationMode,
    Expression<String>? sanctions,
    Expression<String>? socialFund,
    Expression<String>? escrowDetails,
    Expression<bool>? autoRenew,
    Expression<bool>? rulesAcceptedByAll,
    Expression<String>? extraData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (frequency != null) 'frequency': frequency,
      if (contributionAmount != null) 'contribution_amount': contributionAmount,
      if (totalParts != null) 'total_parts': totalParts,
      if (currency != null) 'currency': currency,
      if (status != null) 'status': status,
      if (creatorId != null) 'creator_id': creatorId,
      if (inviteCode != null) 'invite_code': inviteCode,
      if (currentTurn != null) 'current_turn': currentTurn,
      if (startDate != null) 'start_date': startDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rotationMode != null) 'rotation_mode': rotationMode,
      if (validationMode != null) 'validation_mode': validationMode,
      if (sanctions != null) 'sanctions': sanctions,
      if (socialFund != null) 'social_fund': socialFund,
      if (escrowDetails != null) 'escrow_details': escrowDetails,
      if (autoRenew != null) 'auto_renew': autoRenew,
      if (rulesAcceptedByAll != null)
        'rules_accepted_by_all': rulesAcceptedByAll,
      if (extraData != null) 'extra_data': extraData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TontinesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? frequency,
    Value<double>? contributionAmount,
    Value<int>? totalParts,
    Value<String>? currency,
    Value<String>? status,
    Value<String>? creatorId,
    Value<String?>? inviteCode,
    Value<int>? currentTurn,
    Value<DateTime?>? startDate,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String?>? rotationMode,
    Value<String?>? validationMode,
    Value<String?>? sanctions,
    Value<String?>? socialFund,
    Value<String?>? escrowDetails,
    Value<bool?>? autoRenew,
    Value<bool?>? rulesAcceptedByAll,
    Value<String?>? extraData,
    Value<int>? rowid,
  }) {
    return TontinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      contributionAmount: contributionAmount ?? this.contributionAmount,
      totalParts: totalParts ?? this.totalParts,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      creatorId: creatorId ?? this.creatorId,
      inviteCode: inviteCode ?? this.inviteCode,
      currentTurn: currentTurn ?? this.currentTurn,
      startDate: startDate ?? this.startDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rotationMode: rotationMode ?? this.rotationMode,
      validationMode: validationMode ?? this.validationMode,
      sanctions: sanctions ?? this.sanctions,
      socialFund: socialFund ?? this.socialFund,
      escrowDetails: escrowDetails ?? this.escrowDetails,
      autoRenew: autoRenew ?? this.autoRenew,
      rulesAcceptedByAll: rulesAcceptedByAll ?? this.rulesAcceptedByAll,
      extraData: extraData ?? this.extraData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (contributionAmount.present) {
      map['contribution_amount'] = Variable<double>(contributionAmount.value);
    }
    if (totalParts.present) {
      map['total_parts'] = Variable<int>(totalParts.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (creatorId.present) {
      map['creator_id'] = Variable<String>(creatorId.value);
    }
    if (inviteCode.present) {
      map['invite_code'] = Variable<String>(inviteCode.value);
    }
    if (currentTurn.present) {
      map['current_turn'] = Variable<int>(currentTurn.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rotationMode.present) {
      map['rotation_mode'] = Variable<String>(rotationMode.value);
    }
    if (validationMode.present) {
      map['validation_mode'] = Variable<String>(validationMode.value);
    }
    if (sanctions.present) {
      map['sanctions'] = Variable<String>(sanctions.value);
    }
    if (socialFund.present) {
      map['social_fund'] = Variable<String>(socialFund.value);
    }
    if (escrowDetails.present) {
      map['escrow_details'] = Variable<String>(escrowDetails.value);
    }
    if (autoRenew.present) {
      map['auto_renew'] = Variable<bool>(autoRenew.value);
    }
    if (rulesAcceptedByAll.present) {
      map['rules_accepted_by_all'] = Variable<bool>(rulesAcceptedByAll.value);
    }
    if (extraData.present) {
      map['extra_data'] = Variable<String>(extraData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TontinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('frequency: $frequency, ')
          ..write('contributionAmount: $contributionAmount, ')
          ..write('totalParts: $totalParts, ')
          ..write('currency: $currency, ')
          ..write('status: $status, ')
          ..write('creatorId: $creatorId, ')
          ..write('inviteCode: $inviteCode, ')
          ..write('currentTurn: $currentTurn, ')
          ..write('startDate: $startDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rotationMode: $rotationMode, ')
          ..write('validationMode: $validationMode, ')
          ..write('sanctions: $sanctions, ')
          ..write('socialFund: $socialFund, ')
          ..write('escrowDetails: $escrowDetails, ')
          ..write('autoRenew: $autoRenew, ')
          ..write('rulesAcceptedByAll: $rulesAcceptedByAll, ')
          ..write('extraData: $extraData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TontineMembersTable extends TontineMembers
    with TableInfo<$TontineMembersTable, TontineMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TontineMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tontineIdMeta = const VerificationMeta(
    'tontineId',
  );
  @override
  late final GeneratedColumn<String> tontineId = GeneratedColumn<String>(
    'tontine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partsMeta = const VerificationMeta('parts');
  @override
  late final GeneratedColumn<int> parts = GeneratedColumn<int>(
    'parts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _trustScoreMeta = const VerificationMeta(
    'trustScore',
  );
  @override
  late final GeneratedColumn<double> trustScore = GeneratedColumn<double>(
    'trust_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _hasPaidSocialFundMeta = const VerificationMeta(
    'hasPaidSocialFund',
  );
  @override
  late final GeneratedColumn<bool> hasPaidSocialFund = GeneratedColumn<bool>(
    'has_paid_social_fund',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_paid_social_fund" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _payoutDetailsMeta = const VerificationMeta(
    'payoutDetails',
  );
  @override
  late final GeneratedColumn<String> payoutDetails = GeneratedColumn<String>(
    'payout_details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tontineId,
    userId,
    displayName,
    parts,
    trustScore,
    hasPaidSocialFund,
    payoutDetails,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tontine_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<TontineMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tontine_id')) {
      context.handle(
        _tontineIdMeta,
        tontineId.isAcceptableOrUnknown(data['tontine_id']!, _tontineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tontineIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('parts')) {
      context.handle(
        _partsMeta,
        parts.isAcceptableOrUnknown(data['parts']!, _partsMeta),
      );
    }
    if (data.containsKey('trust_score')) {
      context.handle(
        _trustScoreMeta,
        trustScore.isAcceptableOrUnknown(data['trust_score']!, _trustScoreMeta),
      );
    }
    if (data.containsKey('has_paid_social_fund')) {
      context.handle(
        _hasPaidSocialFundMeta,
        hasPaidSocialFund.isAcceptableOrUnknown(
          data['has_paid_social_fund']!,
          _hasPaidSocialFundMeta,
        ),
      );
    }
    if (data.containsKey('payout_details')) {
      context.handle(
        _payoutDetailsMeta,
        payoutDetails.isAcceptableOrUnknown(
          data['payout_details']!,
          _payoutDetailsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TontineMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TontineMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tontineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tontine_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      parts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parts'],
      )!,
      trustScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}trust_score'],
      )!,
      hasPaidSocialFund: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_paid_social_fund'],
      )!,
      payoutDetails: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payout_details'],
      ),
    );
  }

  @override
  $TontineMembersTable createAlias(String alias) {
    return $TontineMembersTable(attachedDatabase, alias);
  }
}

class TontineMember extends DataClass implements Insertable<TontineMember> {
  final String id;
  final String tontineId;
  final String userId;
  final String displayName;
  final int parts;
  final double trustScore;
  final bool hasPaidSocialFund;
  final String? payoutDetails;
  const TontineMember({
    required this.id,
    required this.tontineId,
    required this.userId,
    required this.displayName,
    required this.parts,
    required this.trustScore,
    required this.hasPaidSocialFund,
    this.payoutDetails,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tontine_id'] = Variable<String>(tontineId);
    map['user_id'] = Variable<String>(userId);
    map['display_name'] = Variable<String>(displayName);
    map['parts'] = Variable<int>(parts);
    map['trust_score'] = Variable<double>(trustScore);
    map['has_paid_social_fund'] = Variable<bool>(hasPaidSocialFund);
    if (!nullToAbsent || payoutDetails != null) {
      map['payout_details'] = Variable<String>(payoutDetails);
    }
    return map;
  }

  TontineMembersCompanion toCompanion(bool nullToAbsent) {
    return TontineMembersCompanion(
      id: Value(id),
      tontineId: Value(tontineId),
      userId: Value(userId),
      displayName: Value(displayName),
      parts: Value(parts),
      trustScore: Value(trustScore),
      hasPaidSocialFund: Value(hasPaidSocialFund),
      payoutDetails: payoutDetails == null && nullToAbsent
          ? const Value.absent()
          : Value(payoutDetails),
    );
  }

  factory TontineMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TontineMember(
      id: serializer.fromJson<String>(json['id']),
      tontineId: serializer.fromJson<String>(json['tontineId']),
      userId: serializer.fromJson<String>(json['userId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      parts: serializer.fromJson<int>(json['parts']),
      trustScore: serializer.fromJson<double>(json['trustScore']),
      hasPaidSocialFund: serializer.fromJson<bool>(json['hasPaidSocialFund']),
      payoutDetails: serializer.fromJson<String?>(json['payoutDetails']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tontineId': serializer.toJson<String>(tontineId),
      'userId': serializer.toJson<String>(userId),
      'displayName': serializer.toJson<String>(displayName),
      'parts': serializer.toJson<int>(parts),
      'trustScore': serializer.toJson<double>(trustScore),
      'hasPaidSocialFund': serializer.toJson<bool>(hasPaidSocialFund),
      'payoutDetails': serializer.toJson<String?>(payoutDetails),
    };
  }

  TontineMember copyWith({
    String? id,
    String? tontineId,
    String? userId,
    String? displayName,
    int? parts,
    double? trustScore,
    bool? hasPaidSocialFund,
    Value<String?> payoutDetails = const Value.absent(),
  }) => TontineMember(
    id: id ?? this.id,
    tontineId: tontineId ?? this.tontineId,
    userId: userId ?? this.userId,
    displayName: displayName ?? this.displayName,
    parts: parts ?? this.parts,
    trustScore: trustScore ?? this.trustScore,
    hasPaidSocialFund: hasPaidSocialFund ?? this.hasPaidSocialFund,
    payoutDetails: payoutDetails.present
        ? payoutDetails.value
        : this.payoutDetails,
  );
  TontineMember copyWithCompanion(TontineMembersCompanion data) {
    return TontineMember(
      id: data.id.present ? data.id.value : this.id,
      tontineId: data.tontineId.present ? data.tontineId.value : this.tontineId,
      userId: data.userId.present ? data.userId.value : this.userId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      parts: data.parts.present ? data.parts.value : this.parts,
      trustScore: data.trustScore.present
          ? data.trustScore.value
          : this.trustScore,
      hasPaidSocialFund: data.hasPaidSocialFund.present
          ? data.hasPaidSocialFund.value
          : this.hasPaidSocialFund,
      payoutDetails: data.payoutDetails.present
          ? data.payoutDetails.value
          : this.payoutDetails,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TontineMember(')
          ..write('id: $id, ')
          ..write('tontineId: $tontineId, ')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('parts: $parts, ')
          ..write('trustScore: $trustScore, ')
          ..write('hasPaidSocialFund: $hasPaidSocialFund, ')
          ..write('payoutDetails: $payoutDetails')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tontineId,
    userId,
    displayName,
    parts,
    trustScore,
    hasPaidSocialFund,
    payoutDetails,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TontineMember &&
          other.id == this.id &&
          other.tontineId == this.tontineId &&
          other.userId == this.userId &&
          other.displayName == this.displayName &&
          other.parts == this.parts &&
          other.trustScore == this.trustScore &&
          other.hasPaidSocialFund == this.hasPaidSocialFund &&
          other.payoutDetails == this.payoutDetails);
}

class TontineMembersCompanion extends UpdateCompanion<TontineMember> {
  final Value<String> id;
  final Value<String> tontineId;
  final Value<String> userId;
  final Value<String> displayName;
  final Value<int> parts;
  final Value<double> trustScore;
  final Value<bool> hasPaidSocialFund;
  final Value<String?> payoutDetails;
  final Value<int> rowid;
  const TontineMembersCompanion({
    this.id = const Value.absent(),
    this.tontineId = const Value.absent(),
    this.userId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.parts = const Value.absent(),
    this.trustScore = const Value.absent(),
    this.hasPaidSocialFund = const Value.absent(),
    this.payoutDetails = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TontineMembersCompanion.insert({
    required String id,
    required String tontineId,
    required String userId,
    required String displayName,
    this.parts = const Value.absent(),
    this.trustScore = const Value.absent(),
    this.hasPaidSocialFund = const Value.absent(),
    this.payoutDetails = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tontineId = Value(tontineId),
       userId = Value(userId),
       displayName = Value(displayName);
  static Insertable<TontineMember> custom({
    Expression<String>? id,
    Expression<String>? tontineId,
    Expression<String>? userId,
    Expression<String>? displayName,
    Expression<int>? parts,
    Expression<double>? trustScore,
    Expression<bool>? hasPaidSocialFund,
    Expression<String>? payoutDetails,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tontineId != null) 'tontine_id': tontineId,
      if (userId != null) 'user_id': userId,
      if (displayName != null) 'display_name': displayName,
      if (parts != null) 'parts': parts,
      if (trustScore != null) 'trust_score': trustScore,
      if (hasPaidSocialFund != null) 'has_paid_social_fund': hasPaidSocialFund,
      if (payoutDetails != null) 'payout_details': payoutDetails,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TontineMembersCompanion copyWith({
    Value<String>? id,
    Value<String>? tontineId,
    Value<String>? userId,
    Value<String>? displayName,
    Value<int>? parts,
    Value<double>? trustScore,
    Value<bool>? hasPaidSocialFund,
    Value<String?>? payoutDetails,
    Value<int>? rowid,
  }) {
    return TontineMembersCompanion(
      id: id ?? this.id,
      tontineId: tontineId ?? this.tontineId,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      parts: parts ?? this.parts,
      trustScore: trustScore ?? this.trustScore,
      hasPaidSocialFund: hasPaidSocialFund ?? this.hasPaidSocialFund,
      payoutDetails: payoutDetails ?? this.payoutDetails,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tontineId.present) {
      map['tontine_id'] = Variable<String>(tontineId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (parts.present) {
      map['parts'] = Variable<int>(parts.value);
    }
    if (trustScore.present) {
      map['trust_score'] = Variable<double>(trustScore.value);
    }
    if (hasPaidSocialFund.present) {
      map['has_paid_social_fund'] = Variable<bool>(hasPaidSocialFund.value);
    }
    if (payoutDetails.present) {
      map['payout_details'] = Variable<String>(payoutDetails.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TontineMembersCompanion(')
          ..write('id: $id, ')
          ..write('tontineId: $tontineId, ')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('parts: $parts, ')
          ..write('trustScore: $trustScore, ')
          ..write('hasPaidSocialFund: $hasPaidSocialFund, ')
          ..write('payoutDetails: $payoutDetails, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TontineMessagesTable extends TontineMessages
    with TableInfo<$TontineMessagesTable, TontineMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TontineMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tontineIdMeta = const VerificationMeta(
    'tontineId',
  );
  @override
  late final GeneratedColumn<String> tontineId = GeneratedColumn<String>(
    'tontine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('text'),
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioDurationMeta = const VerificationMeta(
    'audioDuration',
  );
  @override
  late final GeneratedColumn<int> audioDuration = GeneratedColumn<int>(
    'audio_duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tontineId,
    senderId,
    content,
    type,
    audioUrl,
    audioDuration,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tontine_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<TontineMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tontine_id')) {
      context.handle(
        _tontineIdMeta,
        tontineId.isAcceptableOrUnknown(data['tontine_id']!, _tontineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tontineIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('audio_duration')) {
      context.handle(
        _audioDurationMeta,
        audioDuration.isAcceptableOrUnknown(
          data['audio_duration']!,
          _audioDurationMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TontineMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TontineMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tontineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tontine_id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
      audioDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}audio_duration'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TontineMessagesTable createAlias(String alias) {
    return $TontineMessagesTable(attachedDatabase, alias);
  }
}

class TontineMessage extends DataClass implements Insertable<TontineMessage> {
  final String id;
  final String tontineId;
  final String senderId;
  final String content;
  final String type;
  final String? audioUrl;
  final int? audioDuration;
  final DateTime createdAt;
  const TontineMessage({
    required this.id,
    required this.tontineId,
    required this.senderId,
    required this.content,
    required this.type,
    this.audioUrl,
    this.audioDuration,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tontine_id'] = Variable<String>(tontineId);
    map['sender_id'] = Variable<String>(senderId);
    map['content'] = Variable<String>(content);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    if (!nullToAbsent || audioDuration != null) {
      map['audio_duration'] = Variable<int>(audioDuration);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TontineMessagesCompanion toCompanion(bool nullToAbsent) {
    return TontineMessagesCompanion(
      id: Value(id),
      tontineId: Value(tontineId),
      senderId: Value(senderId),
      content: Value(content),
      type: Value(type),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      audioDuration: audioDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(audioDuration),
      createdAt: Value(createdAt),
    );
  }

  factory TontineMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TontineMessage(
      id: serializer.fromJson<String>(json['id']),
      tontineId: serializer.fromJson<String>(json['tontineId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      content: serializer.fromJson<String>(json['content']),
      type: serializer.fromJson<String>(json['type']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      audioDuration: serializer.fromJson<int?>(json['audioDuration']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tontineId': serializer.toJson<String>(tontineId),
      'senderId': serializer.toJson<String>(senderId),
      'content': serializer.toJson<String>(content),
      'type': serializer.toJson<String>(type),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'audioDuration': serializer.toJson<int?>(audioDuration),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TontineMessage copyWith({
    String? id,
    String? tontineId,
    String? senderId,
    String? content,
    String? type,
    Value<String?> audioUrl = const Value.absent(),
    Value<int?> audioDuration = const Value.absent(),
    DateTime? createdAt,
  }) => TontineMessage(
    id: id ?? this.id,
    tontineId: tontineId ?? this.tontineId,
    senderId: senderId ?? this.senderId,
    content: content ?? this.content,
    type: type ?? this.type,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
    audioDuration: audioDuration.present
        ? audioDuration.value
        : this.audioDuration,
    createdAt: createdAt ?? this.createdAt,
  );
  TontineMessage copyWithCompanion(TontineMessagesCompanion data) {
    return TontineMessage(
      id: data.id.present ? data.id.value : this.id,
      tontineId: data.tontineId.present ? data.tontineId.value : this.tontineId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      content: data.content.present ? data.content.value : this.content,
      type: data.type.present ? data.type.value : this.type,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      audioDuration: data.audioDuration.present
          ? data.audioDuration.value
          : this.audioDuration,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TontineMessage(')
          ..write('id: $id, ')
          ..write('tontineId: $tontineId, ')
          ..write('senderId: $senderId, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('audioDuration: $audioDuration, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tontineId,
    senderId,
    content,
    type,
    audioUrl,
    audioDuration,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TontineMessage &&
          other.id == this.id &&
          other.tontineId == this.tontineId &&
          other.senderId == this.senderId &&
          other.content == this.content &&
          other.type == this.type &&
          other.audioUrl == this.audioUrl &&
          other.audioDuration == this.audioDuration &&
          other.createdAt == this.createdAt);
}

class TontineMessagesCompanion extends UpdateCompanion<TontineMessage> {
  final Value<String> id;
  final Value<String> tontineId;
  final Value<String> senderId;
  final Value<String> content;
  final Value<String> type;
  final Value<String?> audioUrl;
  final Value<int?> audioDuration;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TontineMessagesCompanion({
    this.id = const Value.absent(),
    this.tontineId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.content = const Value.absent(),
    this.type = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.audioDuration = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TontineMessagesCompanion.insert({
    required String id,
    required String tontineId,
    required String senderId,
    required String content,
    this.type = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.audioDuration = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tontineId = Value(tontineId),
       senderId = Value(senderId),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<TontineMessage> custom({
    Expression<String>? id,
    Expression<String>? tontineId,
    Expression<String>? senderId,
    Expression<String>? content,
    Expression<String>? type,
    Expression<String>? audioUrl,
    Expression<int>? audioDuration,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tontineId != null) 'tontine_id': tontineId,
      if (senderId != null) 'sender_id': senderId,
      if (content != null) 'content': content,
      if (type != null) 'type': type,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (audioDuration != null) 'audio_duration': audioDuration,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TontineMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? tontineId,
    Value<String>? senderId,
    Value<String>? content,
    Value<String>? type,
    Value<String?>? audioUrl,
    Value<int?>? audioDuration,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TontineMessagesCompanion(
      id: id ?? this.id,
      tontineId: tontineId ?? this.tontineId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      audioUrl: audioUrl ?? this.audioUrl,
      audioDuration: audioDuration ?? this.audioDuration,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tontineId.present) {
      map['tontine_id'] = Variable<String>(tontineId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (audioDuration.present) {
      map['audio_duration'] = Variable<int>(audioDuration.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TontineMessagesCompanion(')
          ..write('id: $id, ')
          ..write('tontineId: $tontineId, ')
          ..write('senderId: $senderId, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('audioDuration: $audioDuration, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TontineContributionsTable extends TontineContributions
    with TableInfo<$TontineContributionsTable, TontineContribution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TontineContributionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tontineIdMeta = const VerificationMeta(
    'tontineId',
  );
  @override
  late final GeneratedColumn<String> tontineId = GeneratedColumn<String>(
    'tontine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _turnIndexMeta = const VerificationMeta(
    'turnIndex',
  );
  @override
  late final GeneratedColumn<int> turnIndex = GeneratedColumn<int>(
    'turn_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPaidMeta = const VerificationMeta(
    'amountPaid',
  );
  @override
  late final GeneratedColumn<double> amountPaid = GeneratedColumn<double>(
    'amount_paid',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proofImageMeta = const VerificationMeta(
    'proofImage',
  );
  @override
  late final GeneratedColumn<String> proofImage = GeneratedColumn<String>(
    'proof_image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validationStatusMeta = const VerificationMeta(
    'validationStatus',
  );
  @override
  late final GeneratedColumn<String> validationStatus = GeneratedColumn<String>(
    'validation_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _aiAnalysisMeta = const VerificationMeta(
    'aiAnalysis',
  );
  @override
  late final GeneratedColumn<String> aiAnalysis = GeneratedColumn<String>(
    'ai_analysis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tontineId,
    memberId,
    turnIndex,
    amountPaid,
    proofImage,
    validationStatus,
    aiAnalysis,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tontine_contributions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TontineContribution> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tontine_id')) {
      context.handle(
        _tontineIdMeta,
        tontineId.isAcceptableOrUnknown(data['tontine_id']!, _tontineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tontineIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('turn_index')) {
      context.handle(
        _turnIndexMeta,
        turnIndex.isAcceptableOrUnknown(data['turn_index']!, _turnIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_turnIndexMeta);
    }
    if (data.containsKey('amount_paid')) {
      context.handle(
        _amountPaidMeta,
        amountPaid.isAcceptableOrUnknown(data['amount_paid']!, _amountPaidMeta),
      );
    } else if (isInserting) {
      context.missing(_amountPaidMeta);
    }
    if (data.containsKey('proof_image')) {
      context.handle(
        _proofImageMeta,
        proofImage.isAcceptableOrUnknown(data['proof_image']!, _proofImageMeta),
      );
    }
    if (data.containsKey('validation_status')) {
      context.handle(
        _validationStatusMeta,
        validationStatus.isAcceptableOrUnknown(
          data['validation_status']!,
          _validationStatusMeta,
        ),
      );
    }
    if (data.containsKey('ai_analysis')) {
      context.handle(
        _aiAnalysisMeta,
        aiAnalysis.isAcceptableOrUnknown(data['ai_analysis']!, _aiAnalysisMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TontineContribution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TontineContribution(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tontineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tontine_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      turnIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}turn_index'],
      )!,
      amountPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_paid'],
      )!,
      proofImage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proof_image'],
      ),
      validationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}validation_status'],
      )!,
      aiAnalysis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_analysis'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TontineContributionsTable createAlias(String alias) {
    return $TontineContributionsTable(attachedDatabase, alias);
  }
}

class TontineContribution extends DataClass
    implements Insertable<TontineContribution> {
  final String id;
  final String tontineId;
  final String memberId;
  final int turnIndex;
  final double amountPaid;
  final String? proofImage;
  final String validationStatus;
  final String? aiAnalysis;
  final DateTime createdAt;
  const TontineContribution({
    required this.id,
    required this.tontineId,
    required this.memberId,
    required this.turnIndex,
    required this.amountPaid,
    this.proofImage,
    required this.validationStatus,
    this.aiAnalysis,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tontine_id'] = Variable<String>(tontineId);
    map['member_id'] = Variable<String>(memberId);
    map['turn_index'] = Variable<int>(turnIndex);
    map['amount_paid'] = Variable<double>(amountPaid);
    if (!nullToAbsent || proofImage != null) {
      map['proof_image'] = Variable<String>(proofImage);
    }
    map['validation_status'] = Variable<String>(validationStatus);
    if (!nullToAbsent || aiAnalysis != null) {
      map['ai_analysis'] = Variable<String>(aiAnalysis);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TontineContributionsCompanion toCompanion(bool nullToAbsent) {
    return TontineContributionsCompanion(
      id: Value(id),
      tontineId: Value(tontineId),
      memberId: Value(memberId),
      turnIndex: Value(turnIndex),
      amountPaid: Value(amountPaid),
      proofImage: proofImage == null && nullToAbsent
          ? const Value.absent()
          : Value(proofImage),
      validationStatus: Value(validationStatus),
      aiAnalysis: aiAnalysis == null && nullToAbsent
          ? const Value.absent()
          : Value(aiAnalysis),
      createdAt: Value(createdAt),
    );
  }

  factory TontineContribution.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TontineContribution(
      id: serializer.fromJson<String>(json['id']),
      tontineId: serializer.fromJson<String>(json['tontineId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      turnIndex: serializer.fromJson<int>(json['turnIndex']),
      amountPaid: serializer.fromJson<double>(json['amountPaid']),
      proofImage: serializer.fromJson<String?>(json['proofImage']),
      validationStatus: serializer.fromJson<String>(json['validationStatus']),
      aiAnalysis: serializer.fromJson<String?>(json['aiAnalysis']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tontineId': serializer.toJson<String>(tontineId),
      'memberId': serializer.toJson<String>(memberId),
      'turnIndex': serializer.toJson<int>(turnIndex),
      'amountPaid': serializer.toJson<double>(amountPaid),
      'proofImage': serializer.toJson<String?>(proofImage),
      'validationStatus': serializer.toJson<String>(validationStatus),
      'aiAnalysis': serializer.toJson<String?>(aiAnalysis),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TontineContribution copyWith({
    String? id,
    String? tontineId,
    String? memberId,
    int? turnIndex,
    double? amountPaid,
    Value<String?> proofImage = const Value.absent(),
    String? validationStatus,
    Value<String?> aiAnalysis = const Value.absent(),
    DateTime? createdAt,
  }) => TontineContribution(
    id: id ?? this.id,
    tontineId: tontineId ?? this.tontineId,
    memberId: memberId ?? this.memberId,
    turnIndex: turnIndex ?? this.turnIndex,
    amountPaid: amountPaid ?? this.amountPaid,
    proofImage: proofImage.present ? proofImage.value : this.proofImage,
    validationStatus: validationStatus ?? this.validationStatus,
    aiAnalysis: aiAnalysis.present ? aiAnalysis.value : this.aiAnalysis,
    createdAt: createdAt ?? this.createdAt,
  );
  TontineContribution copyWithCompanion(TontineContributionsCompanion data) {
    return TontineContribution(
      id: data.id.present ? data.id.value : this.id,
      tontineId: data.tontineId.present ? data.tontineId.value : this.tontineId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      turnIndex: data.turnIndex.present ? data.turnIndex.value : this.turnIndex,
      amountPaid: data.amountPaid.present
          ? data.amountPaid.value
          : this.amountPaid,
      proofImage: data.proofImage.present
          ? data.proofImage.value
          : this.proofImage,
      validationStatus: data.validationStatus.present
          ? data.validationStatus.value
          : this.validationStatus,
      aiAnalysis: data.aiAnalysis.present
          ? data.aiAnalysis.value
          : this.aiAnalysis,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TontineContribution(')
          ..write('id: $id, ')
          ..write('tontineId: $tontineId, ')
          ..write('memberId: $memberId, ')
          ..write('turnIndex: $turnIndex, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('proofImage: $proofImage, ')
          ..write('validationStatus: $validationStatus, ')
          ..write('aiAnalysis: $aiAnalysis, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tontineId,
    memberId,
    turnIndex,
    amountPaid,
    proofImage,
    validationStatus,
    aiAnalysis,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TontineContribution &&
          other.id == this.id &&
          other.tontineId == this.tontineId &&
          other.memberId == this.memberId &&
          other.turnIndex == this.turnIndex &&
          other.amountPaid == this.amountPaid &&
          other.proofImage == this.proofImage &&
          other.validationStatus == this.validationStatus &&
          other.aiAnalysis == this.aiAnalysis &&
          other.createdAt == this.createdAt);
}

class TontineContributionsCompanion
    extends UpdateCompanion<TontineContribution> {
  final Value<String> id;
  final Value<String> tontineId;
  final Value<String> memberId;
  final Value<int> turnIndex;
  final Value<double> amountPaid;
  final Value<String?> proofImage;
  final Value<String> validationStatus;
  final Value<String?> aiAnalysis;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TontineContributionsCompanion({
    this.id = const Value.absent(),
    this.tontineId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.turnIndex = const Value.absent(),
    this.amountPaid = const Value.absent(),
    this.proofImage = const Value.absent(),
    this.validationStatus = const Value.absent(),
    this.aiAnalysis = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TontineContributionsCompanion.insert({
    required String id,
    required String tontineId,
    required String memberId,
    required int turnIndex,
    required double amountPaid,
    this.proofImage = const Value.absent(),
    this.validationStatus = const Value.absent(),
    this.aiAnalysis = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tontineId = Value(tontineId),
       memberId = Value(memberId),
       turnIndex = Value(turnIndex),
       amountPaid = Value(amountPaid),
       createdAt = Value(createdAt);
  static Insertable<TontineContribution> custom({
    Expression<String>? id,
    Expression<String>? tontineId,
    Expression<String>? memberId,
    Expression<int>? turnIndex,
    Expression<double>? amountPaid,
    Expression<String>? proofImage,
    Expression<String>? validationStatus,
    Expression<String>? aiAnalysis,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tontineId != null) 'tontine_id': tontineId,
      if (memberId != null) 'member_id': memberId,
      if (turnIndex != null) 'turn_index': turnIndex,
      if (amountPaid != null) 'amount_paid': amountPaid,
      if (proofImage != null) 'proof_image': proofImage,
      if (validationStatus != null) 'validation_status': validationStatus,
      if (aiAnalysis != null) 'ai_analysis': aiAnalysis,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TontineContributionsCompanion copyWith({
    Value<String>? id,
    Value<String>? tontineId,
    Value<String>? memberId,
    Value<int>? turnIndex,
    Value<double>? amountPaid,
    Value<String?>? proofImage,
    Value<String>? validationStatus,
    Value<String?>? aiAnalysis,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TontineContributionsCompanion(
      id: id ?? this.id,
      tontineId: tontineId ?? this.tontineId,
      memberId: memberId ?? this.memberId,
      turnIndex: turnIndex ?? this.turnIndex,
      amountPaid: amountPaid ?? this.amountPaid,
      proofImage: proofImage ?? this.proofImage,
      validationStatus: validationStatus ?? this.validationStatus,
      aiAnalysis: aiAnalysis ?? this.aiAnalysis,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tontineId.present) {
      map['tontine_id'] = Variable<String>(tontineId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (turnIndex.present) {
      map['turn_index'] = Variable<int>(turnIndex.value);
    }
    if (amountPaid.present) {
      map['amount_paid'] = Variable<double>(amountPaid.value);
    }
    if (proofImage.present) {
      map['proof_image'] = Variable<String>(proofImage.value);
    }
    if (validationStatus.present) {
      map['validation_status'] = Variable<String>(validationStatus.value);
    }
    if (aiAnalysis.present) {
      map['ai_analysis'] = Variable<String>(aiAnalysis.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TontineContributionsCompanion(')
          ..write('id: $id, ')
          ..write('tontineId: $tontineId, ')
          ..write('memberId: $memberId, ')
          ..write('turnIndex: $turnIndex, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('proofImage: $proofImage, ')
          ..write('validationStatus: $validationStatus, ')
          ..write('aiAnalysis: $aiAnalysis, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DashboardReportsTable extends DashboardReports
    with TableInfo<$DashboardReportsTable, DashboardReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DashboardReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _walletBalanceMeta = const VerificationMeta(
    'walletBalance',
  );
  @override
  late final GeneratedColumn<double> walletBalance = GeneratedColumn<double>(
    'wallet_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyIncomeMeta = const VerificationMeta(
    'monthlyIncome',
  );
  @override
  late final GeneratedColumn<double> monthlyIncome = GeneratedColumn<double>(
    'monthly_income',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalSpentMeta = const VerificationMeta(
    'totalSpent',
  );
  @override
  late final GeneratedColumn<double> totalSpent = GeneratedColumn<double>(
    'total_spent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savingsRateMeta = const VerificationMeta(
    'savingsRate',
  );
  @override
  late final GeneratedColumn<double> savingsRate = GeneratedColumn<double>(
    'savings_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('XAF'),
  );
  static const VerificationMeta _budgetHealthMeta = const VerificationMeta(
    'budgetHealth',
  );
  @override
  late final GeneratedColumn<String> budgetHealth = GeneratedColumn<String>(
    'budget_health',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletBalance,
    monthlyIncome,
    totalSpent,
    savingsRate,
    currency,
    budgetHealth,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dashboard_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<DashboardReport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wallet_balance')) {
      context.handle(
        _walletBalanceMeta,
        walletBalance.isAcceptableOrUnknown(
          data['wallet_balance']!,
          _walletBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_walletBalanceMeta);
    }
    if (data.containsKey('monthly_income')) {
      context.handle(
        _monthlyIncomeMeta,
        monthlyIncome.isAcceptableOrUnknown(
          data['monthly_income']!,
          _monthlyIncomeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyIncomeMeta);
    }
    if (data.containsKey('total_spent')) {
      context.handle(
        _totalSpentMeta,
        totalSpent.isAcceptableOrUnknown(data['total_spent']!, _totalSpentMeta),
      );
    } else if (isInserting) {
      context.missing(_totalSpentMeta);
    }
    if (data.containsKey('savings_rate')) {
      context.handle(
        _savingsRateMeta,
        savingsRate.isAcceptableOrUnknown(
          data['savings_rate']!,
          _savingsRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_savingsRateMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('budget_health')) {
      context.handle(
        _budgetHealthMeta,
        budgetHealth.isAcceptableOrUnknown(
          data['budget_health']!,
          _budgetHealthMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DashboardReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DashboardReport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      walletBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}wallet_balance'],
      )!,
      monthlyIncome: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_income'],
      )!,
      totalSpent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_spent'],
      )!,
      savingsRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}savings_rate'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      budgetHealth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_health'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $DashboardReportsTable createAlias(String alias) {
    return $DashboardReportsTable(attachedDatabase, alias);
  }
}

class DashboardReport extends DataClass implements Insertable<DashboardReport> {
  final int id;
  final double walletBalance;
  final double monthlyIncome;
  final double totalSpent;
  final double savingsRate;
  final String currency;
  final String? budgetHealth;
  final DateTime cachedAt;
  const DashboardReport({
    required this.id,
    required this.walletBalance,
    required this.monthlyIncome,
    required this.totalSpent,
    required this.savingsRate,
    required this.currency,
    this.budgetHealth,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wallet_balance'] = Variable<double>(walletBalance);
    map['monthly_income'] = Variable<double>(monthlyIncome);
    map['total_spent'] = Variable<double>(totalSpent);
    map['savings_rate'] = Variable<double>(savingsRate);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || budgetHealth != null) {
      map['budget_health'] = Variable<String>(budgetHealth);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  DashboardReportsCompanion toCompanion(bool nullToAbsent) {
    return DashboardReportsCompanion(
      id: Value(id),
      walletBalance: Value(walletBalance),
      monthlyIncome: Value(monthlyIncome),
      totalSpent: Value(totalSpent),
      savingsRate: Value(savingsRate),
      currency: Value(currency),
      budgetHealth: budgetHealth == null && nullToAbsent
          ? const Value.absent()
          : Value(budgetHealth),
      cachedAt: Value(cachedAt),
    );
  }

  factory DashboardReport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DashboardReport(
      id: serializer.fromJson<int>(json['id']),
      walletBalance: serializer.fromJson<double>(json['walletBalance']),
      monthlyIncome: serializer.fromJson<double>(json['monthlyIncome']),
      totalSpent: serializer.fromJson<double>(json['totalSpent']),
      savingsRate: serializer.fromJson<double>(json['savingsRate']),
      currency: serializer.fromJson<String>(json['currency']),
      budgetHealth: serializer.fromJson<String?>(json['budgetHealth']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'walletBalance': serializer.toJson<double>(walletBalance),
      'monthlyIncome': serializer.toJson<double>(monthlyIncome),
      'totalSpent': serializer.toJson<double>(totalSpent),
      'savingsRate': serializer.toJson<double>(savingsRate),
      'currency': serializer.toJson<String>(currency),
      'budgetHealth': serializer.toJson<String?>(budgetHealth),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  DashboardReport copyWith({
    int? id,
    double? walletBalance,
    double? monthlyIncome,
    double? totalSpent,
    double? savingsRate,
    String? currency,
    Value<String?> budgetHealth = const Value.absent(),
    DateTime? cachedAt,
  }) => DashboardReport(
    id: id ?? this.id,
    walletBalance: walletBalance ?? this.walletBalance,
    monthlyIncome: monthlyIncome ?? this.monthlyIncome,
    totalSpent: totalSpent ?? this.totalSpent,
    savingsRate: savingsRate ?? this.savingsRate,
    currency: currency ?? this.currency,
    budgetHealth: budgetHealth.present ? budgetHealth.value : this.budgetHealth,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  DashboardReport copyWithCompanion(DashboardReportsCompanion data) {
    return DashboardReport(
      id: data.id.present ? data.id.value : this.id,
      walletBalance: data.walletBalance.present
          ? data.walletBalance.value
          : this.walletBalance,
      monthlyIncome: data.monthlyIncome.present
          ? data.monthlyIncome.value
          : this.monthlyIncome,
      totalSpent: data.totalSpent.present
          ? data.totalSpent.value
          : this.totalSpent,
      savingsRate: data.savingsRate.present
          ? data.savingsRate.value
          : this.savingsRate,
      currency: data.currency.present ? data.currency.value : this.currency,
      budgetHealth: data.budgetHealth.present
          ? data.budgetHealth.value
          : this.budgetHealth,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DashboardReport(')
          ..write('id: $id, ')
          ..write('walletBalance: $walletBalance, ')
          ..write('monthlyIncome: $monthlyIncome, ')
          ..write('totalSpent: $totalSpent, ')
          ..write('savingsRate: $savingsRate, ')
          ..write('currency: $currency, ')
          ..write('budgetHealth: $budgetHealth, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletBalance,
    monthlyIncome,
    totalSpent,
    savingsRate,
    currency,
    budgetHealth,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DashboardReport &&
          other.id == this.id &&
          other.walletBalance == this.walletBalance &&
          other.monthlyIncome == this.monthlyIncome &&
          other.totalSpent == this.totalSpent &&
          other.savingsRate == this.savingsRate &&
          other.currency == this.currency &&
          other.budgetHealth == this.budgetHealth &&
          other.cachedAt == this.cachedAt);
}

class DashboardReportsCompanion extends UpdateCompanion<DashboardReport> {
  final Value<int> id;
  final Value<double> walletBalance;
  final Value<double> monthlyIncome;
  final Value<double> totalSpent;
  final Value<double> savingsRate;
  final Value<String> currency;
  final Value<String?> budgetHealth;
  final Value<DateTime> cachedAt;
  const DashboardReportsCompanion({
    this.id = const Value.absent(),
    this.walletBalance = const Value.absent(),
    this.monthlyIncome = const Value.absent(),
    this.totalSpent = const Value.absent(),
    this.savingsRate = const Value.absent(),
    this.currency = const Value.absent(),
    this.budgetHealth = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  DashboardReportsCompanion.insert({
    this.id = const Value.absent(),
    required double walletBalance,
    required double monthlyIncome,
    required double totalSpent,
    required double savingsRate,
    this.currency = const Value.absent(),
    this.budgetHealth = const Value.absent(),
    required DateTime cachedAt,
  }) : walletBalance = Value(walletBalance),
       monthlyIncome = Value(monthlyIncome),
       totalSpent = Value(totalSpent),
       savingsRate = Value(savingsRate),
       cachedAt = Value(cachedAt);
  static Insertable<DashboardReport> custom({
    Expression<int>? id,
    Expression<double>? walletBalance,
    Expression<double>? monthlyIncome,
    Expression<double>? totalSpent,
    Expression<double>? savingsRate,
    Expression<String>? currency,
    Expression<String>? budgetHealth,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletBalance != null) 'wallet_balance': walletBalance,
      if (monthlyIncome != null) 'monthly_income': monthlyIncome,
      if (totalSpent != null) 'total_spent': totalSpent,
      if (savingsRate != null) 'savings_rate': savingsRate,
      if (currency != null) 'currency': currency,
      if (budgetHealth != null) 'budget_health': budgetHealth,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  DashboardReportsCompanion copyWith({
    Value<int>? id,
    Value<double>? walletBalance,
    Value<double>? monthlyIncome,
    Value<double>? totalSpent,
    Value<double>? savingsRate,
    Value<String>? currency,
    Value<String?>? budgetHealth,
    Value<DateTime>? cachedAt,
  }) {
    return DashboardReportsCompanion(
      id: id ?? this.id,
      walletBalance: walletBalance ?? this.walletBalance,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      totalSpent: totalSpent ?? this.totalSpent,
      savingsRate: savingsRate ?? this.savingsRate,
      currency: currency ?? this.currency,
      budgetHealth: budgetHealth ?? this.budgetHealth,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (walletBalance.present) {
      map['wallet_balance'] = Variable<double>(walletBalance.value);
    }
    if (monthlyIncome.present) {
      map['monthly_income'] = Variable<double>(monthlyIncome.value);
    }
    if (totalSpent.present) {
      map['total_spent'] = Variable<double>(totalSpent.value);
    }
    if (savingsRate.present) {
      map['savings_rate'] = Variable<double>(savingsRate.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (budgetHealth.present) {
      map['budget_health'] = Variable<String>(budgetHealth.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DashboardReportsCompanion(')
          ..write('id: $id, ')
          ..write('walletBalance: $walletBalance, ')
          ..write('monthlyIncome: $monthlyIncome, ')
          ..write('totalSpent: $totalSpent, ')
          ..write('savingsRate: $savingsRate, ')
          ..write('currency: $currency, ')
          ..write('budgetHealth: $budgetHealth, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $SpendingAnalysisCacheTable extends SpendingAnalysisCache
    with TableInfo<$SpendingAnalysisCacheTable, SpendingAnalysisCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpendingAnalysisCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [period, dataJson, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spending_analysis_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpendingAnalysisCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {period};
  @override
  SpendingAnalysisCacheData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpendingAnalysisCacheData(
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $SpendingAnalysisCacheTable createAlias(String alias) {
    return $SpendingAnalysisCacheTable(attachedDatabase, alias);
  }
}

class SpendingAnalysisCacheData extends DataClass
    implements Insertable<SpendingAnalysisCacheData> {
  final String period;
  final String dataJson;
  final DateTime cachedAt;
  const SpendingAnalysisCacheData({
    required this.period,
    required this.dataJson,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['period'] = Variable<String>(period);
    map['data_json'] = Variable<String>(dataJson);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  SpendingAnalysisCacheCompanion toCompanion(bool nullToAbsent) {
    return SpendingAnalysisCacheCompanion(
      period: Value(period),
      dataJson: Value(dataJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory SpendingAnalysisCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpendingAnalysisCacheData(
      period: serializer.fromJson<String>(json['period']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'period': serializer.toJson<String>(period),
      'dataJson': serializer.toJson<String>(dataJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  SpendingAnalysisCacheData copyWith({
    String? period,
    String? dataJson,
    DateTime? cachedAt,
  }) => SpendingAnalysisCacheData(
    period: period ?? this.period,
    dataJson: dataJson ?? this.dataJson,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  SpendingAnalysisCacheData copyWithCompanion(
    SpendingAnalysisCacheCompanion data,
  ) {
    return SpendingAnalysisCacheData(
      period: data.period.present ? data.period.value : this.period,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpendingAnalysisCacheData(')
          ..write('period: $period, ')
          ..write('dataJson: $dataJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(period, dataJson, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpendingAnalysisCacheData &&
          other.period == this.period &&
          other.dataJson == this.dataJson &&
          other.cachedAt == this.cachedAt);
}

class SpendingAnalysisCacheCompanion
    extends UpdateCompanion<SpendingAnalysisCacheData> {
  final Value<String> period;
  final Value<String> dataJson;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const SpendingAnalysisCacheCompanion({
    this.period = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpendingAnalysisCacheCompanion.insert({
    required String period,
    required String dataJson,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : period = Value(period),
       dataJson = Value(dataJson),
       cachedAt = Value(cachedAt);
  static Insertable<SpendingAnalysisCacheData> custom({
    Expression<String>? period,
    Expression<String>? dataJson,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (period != null) 'period': period,
      if (dataJson != null) 'data_json': dataJson,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpendingAnalysisCacheCompanion copyWith({
    Value<String>? period,
    Value<String>? dataJson,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return SpendingAnalysisCacheCompanion(
      period: period ?? this.period,
      dataJson: dataJson ?? this.dataJson,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpendingAnalysisCacheCompanion(')
          ..write('period: $period, ')
          ..write('dataJson: $dataJson, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavingsTrendCacheTable extends SavingsTrendCache
    with TableInfo<$SavingsTrendCacheTable, SavingsTrendCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsTrendCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [period, dataJson, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_trend_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsTrendCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {period};
  @override
  SavingsTrendCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsTrendCacheData(
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $SavingsTrendCacheTable createAlias(String alias) {
    return $SavingsTrendCacheTable(attachedDatabase, alias);
  }
}

class SavingsTrendCacheData extends DataClass
    implements Insertable<SavingsTrendCacheData> {
  final String period;
  final String dataJson;
  final DateTime cachedAt;
  const SavingsTrendCacheData({
    required this.period,
    required this.dataJson,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['period'] = Variable<String>(period);
    map['data_json'] = Variable<String>(dataJson);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  SavingsTrendCacheCompanion toCompanion(bool nullToAbsent) {
    return SavingsTrendCacheCompanion(
      period: Value(period),
      dataJson: Value(dataJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory SavingsTrendCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsTrendCacheData(
      period: serializer.fromJson<String>(json['period']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'period': serializer.toJson<String>(period),
      'dataJson': serializer.toJson<String>(dataJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  SavingsTrendCacheData copyWith({
    String? period,
    String? dataJson,
    DateTime? cachedAt,
  }) => SavingsTrendCacheData(
    period: period ?? this.period,
    dataJson: dataJson ?? this.dataJson,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  SavingsTrendCacheData copyWithCompanion(SavingsTrendCacheCompanion data) {
    return SavingsTrendCacheData(
      period: data.period.present ? data.period.value : this.period,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsTrendCacheData(')
          ..write('period: $period, ')
          ..write('dataJson: $dataJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(period, dataJson, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsTrendCacheData &&
          other.period == this.period &&
          other.dataJson == this.dataJson &&
          other.cachedAt == this.cachedAt);
}

class SavingsTrendCacheCompanion
    extends UpdateCompanion<SavingsTrendCacheData> {
  final Value<String> period;
  final Value<String> dataJson;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const SavingsTrendCacheCompanion({
    this.period = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavingsTrendCacheCompanion.insert({
    required String period,
    required String dataJson,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : period = Value(period),
       dataJson = Value(dataJson),
       cachedAt = Value(cachedAt);
  static Insertable<SavingsTrendCacheData> custom({
    Expression<String>? period,
    Expression<String>? dataJson,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (period != null) 'period': period,
      if (dataJson != null) 'data_json': dataJson,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavingsTrendCacheCompanion copyWith({
    Value<String>? period,
    Value<String>? dataJson,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return SavingsTrendCacheCompanion(
      period: period ?? this.period,
      dataJson: dataJson ?? this.dataJson,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsTrendCacheCompanion(')
          ..write('period: $period, ')
          ..write('dataJson: $dataJson, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NarrativeReportCacheTable extends NarrativeReportCache
    with TableInfo<$NarrativeReportCacheTable, NarrativeReportCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NarrativeReportCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, dataJson, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'narrative_report_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<NarrativeReportCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NarrativeReportCacheData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NarrativeReportCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $NarrativeReportCacheTable createAlias(String alias) {
    return $NarrativeReportCacheTable(attachedDatabase, alias);
  }
}

class NarrativeReportCacheData extends DataClass
    implements Insertable<NarrativeReportCacheData> {
  final int id;
  final String dataJson;
  final DateTime cachedAt;
  const NarrativeReportCacheData({
    required this.id,
    required this.dataJson,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['data_json'] = Variable<String>(dataJson);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  NarrativeReportCacheCompanion toCompanion(bool nullToAbsent) {
    return NarrativeReportCacheCompanion(
      id: Value(id),
      dataJson: Value(dataJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory NarrativeReportCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NarrativeReportCacheData(
      id: serializer.fromJson<int>(json['id']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dataJson': serializer.toJson<String>(dataJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  NarrativeReportCacheData copyWith({
    int? id,
    String? dataJson,
    DateTime? cachedAt,
  }) => NarrativeReportCacheData(
    id: id ?? this.id,
    dataJson: dataJson ?? this.dataJson,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  NarrativeReportCacheData copyWithCompanion(
    NarrativeReportCacheCompanion data,
  ) {
    return NarrativeReportCacheData(
      id: data.id.present ? data.id.value : this.id,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NarrativeReportCacheData(')
          ..write('id: $id, ')
          ..write('dataJson: $dataJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dataJson, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NarrativeReportCacheData &&
          other.id == this.id &&
          other.dataJson == this.dataJson &&
          other.cachedAt == this.cachedAt);
}

class NarrativeReportCacheCompanion
    extends UpdateCompanion<NarrativeReportCacheData> {
  final Value<int> id;
  final Value<String> dataJson;
  final Value<DateTime> cachedAt;
  const NarrativeReportCacheCompanion({
    this.id = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  NarrativeReportCacheCompanion.insert({
    this.id = const Value.absent(),
    required String dataJson,
    required DateTime cachedAt,
  }) : dataJson = Value(dataJson),
       cachedAt = Value(cachedAt);
  static Insertable<NarrativeReportCacheData> custom({
    Expression<int>? id,
    Expression<String>? dataJson,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dataJson != null) 'data_json': dataJson,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  NarrativeReportCacheCompanion copyWith({
    Value<int>? id,
    Value<String>? dataJson,
    Value<DateTime>? cachedAt,
  }) {
    return NarrativeReportCacheCompanion(
      id: id ?? this.id,
      dataJson: dataJson ?? this.dataJson,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NarrativeReportCacheCompanion(')
          ..write('id: $id, ')
          ..write('dataJson: $dataJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $ForecastCacheTable extends ForecastCache
    with TableInfo<$ForecastCacheTable, ForecastCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ForecastCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, dataJson, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'forecast_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<ForecastCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ForecastCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ForecastCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $ForecastCacheTable createAlias(String alias) {
    return $ForecastCacheTable(attachedDatabase, alias);
  }
}

class ForecastCacheData extends DataClass
    implements Insertable<ForecastCacheData> {
  final int id;
  final String dataJson;
  final DateTime cachedAt;
  const ForecastCacheData({
    required this.id,
    required this.dataJson,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['data_json'] = Variable<String>(dataJson);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  ForecastCacheCompanion toCompanion(bool nullToAbsent) {
    return ForecastCacheCompanion(
      id: Value(id),
      dataJson: Value(dataJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory ForecastCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ForecastCacheData(
      id: serializer.fromJson<int>(json['id']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dataJson': serializer.toJson<String>(dataJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  ForecastCacheData copyWith({int? id, String? dataJson, DateTime? cachedAt}) =>
      ForecastCacheData(
        id: id ?? this.id,
        dataJson: dataJson ?? this.dataJson,
        cachedAt: cachedAt ?? this.cachedAt,
      );
  ForecastCacheData copyWithCompanion(ForecastCacheCompanion data) {
    return ForecastCacheData(
      id: data.id.present ? data.id.value : this.id,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ForecastCacheData(')
          ..write('id: $id, ')
          ..write('dataJson: $dataJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dataJson, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ForecastCacheData &&
          other.id == this.id &&
          other.dataJson == this.dataJson &&
          other.cachedAt == this.cachedAt);
}

class ForecastCacheCompanion extends UpdateCompanion<ForecastCacheData> {
  final Value<int> id;
  final Value<String> dataJson;
  final Value<DateTime> cachedAt;
  const ForecastCacheCompanion({
    this.id = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  ForecastCacheCompanion.insert({
    this.id = const Value.absent(),
    required String dataJson,
    required DateTime cachedAt,
  }) : dataJson = Value(dataJson),
       cachedAt = Value(cachedAt);
  static Insertable<ForecastCacheData> custom({
    Expression<int>? id,
    Expression<String>? dataJson,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dataJson != null) 'data_json': dataJson,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  ForecastCacheCompanion copyWith({
    Value<int>? id,
    Value<String>? dataJson,
    Value<DateTime>? cachedAt,
  }) {
    return ForecastCacheCompanion(
      id: id ?? this.id,
      dataJson: dataJson ?? this.dataJson,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ForecastCacheCompanion(')
          ..write('id: $id, ')
          ..write('dataJson: $dataJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $HealthScoreHistoryCacheTable extends HealthScoreHistoryCache
    with TableInfo<$HealthScoreHistoryCacheTable, HealthScoreHistoryCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthScoreHistoryCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, dataJson, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_score_history_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthScoreHistoryCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthScoreHistoryCacheData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthScoreHistoryCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $HealthScoreHistoryCacheTable createAlias(String alias) {
    return $HealthScoreHistoryCacheTable(attachedDatabase, alias);
  }
}

class HealthScoreHistoryCacheData extends DataClass
    implements Insertable<HealthScoreHistoryCacheData> {
  final int id;
  final String dataJson;
  final DateTime cachedAt;
  const HealthScoreHistoryCacheData({
    required this.id,
    required this.dataJson,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['data_json'] = Variable<String>(dataJson);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  HealthScoreHistoryCacheCompanion toCompanion(bool nullToAbsent) {
    return HealthScoreHistoryCacheCompanion(
      id: Value(id),
      dataJson: Value(dataJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory HealthScoreHistoryCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthScoreHistoryCacheData(
      id: serializer.fromJson<int>(json['id']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dataJson': serializer.toJson<String>(dataJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  HealthScoreHistoryCacheData copyWith({
    int? id,
    String? dataJson,
    DateTime? cachedAt,
  }) => HealthScoreHistoryCacheData(
    id: id ?? this.id,
    dataJson: dataJson ?? this.dataJson,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  HealthScoreHistoryCacheData copyWithCompanion(
    HealthScoreHistoryCacheCompanion data,
  ) {
    return HealthScoreHistoryCacheData(
      id: data.id.present ? data.id.value : this.id,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthScoreHistoryCacheData(')
          ..write('id: $id, ')
          ..write('dataJson: $dataJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dataJson, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthScoreHistoryCacheData &&
          other.id == this.id &&
          other.dataJson == this.dataJson &&
          other.cachedAt == this.cachedAt);
}

class HealthScoreHistoryCacheCompanion
    extends UpdateCompanion<HealthScoreHistoryCacheData> {
  final Value<int> id;
  final Value<String> dataJson;
  final Value<DateTime> cachedAt;
  const HealthScoreHistoryCacheCompanion({
    this.id = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  HealthScoreHistoryCacheCompanion.insert({
    this.id = const Value.absent(),
    required String dataJson,
    required DateTime cachedAt,
  }) : dataJson = Value(dataJson),
       cachedAt = Value(cachedAt);
  static Insertable<HealthScoreHistoryCacheData> custom({
    Expression<int>? id,
    Expression<String>? dataJson,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dataJson != null) 'data_json': dataJson,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  HealthScoreHistoryCacheCompanion copyWith({
    Value<int>? id,
    Value<String>? dataJson,
    Value<DateTime>? cachedAt,
  }) {
    return HealthScoreHistoryCacheCompanion(
      id: id ?? this.id,
      dataJson: dataJson ?? this.dataJson,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthScoreHistoryCacheCompanion(')
          ..write('id: $id, ')
          ..write('dataJson: $dataJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $ChallengesTable challenges = $ChallengesTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  late final $InvestmentsTable investments = $InvestmentsTable(this);
  late final $SyncRequestsTable syncRequests = $SyncRequestsTable(this);
  late final $UserSubscriptionsTable userSubscriptions =
      $UserSubscriptionsTable(this);
  late final $UserChallengesTable userChallenges = $UserChallengesTable(this);
  late final $TontinesTable tontines = $TontinesTable(this);
  late final $TontineMembersTable tontineMembers = $TontineMembersTable(this);
  late final $TontineMessagesTable tontineMessages = $TontineMessagesTable(
    this,
  );
  late final $TontineContributionsTable tontineContributions =
      $TontineContributionsTable(this);
  late final $DashboardReportsTable dashboardReports = $DashboardReportsTable(
    this,
  );
  late final $SpendingAnalysisCacheTable spendingAnalysisCache =
      $SpendingAnalysisCacheTable(this);
  late final $SavingsTrendCacheTable savingsTrendCache =
      $SavingsTrendCacheTable(this);
  late final $NarrativeReportCacheTable narrativeReportCache =
      $NarrativeReportCacheTable(this);
  late final $ForecastCacheTable forecastCache = $ForecastCacheTable(this);
  late final $HealthScoreHistoryCacheTable healthScoreHistoryCache =
      $HealthScoreHistoryCacheTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    transactions,
    budgets,
    goals,
    challenges,
    chatMessages,
    investments,
    syncRequests,
    userSubscriptions,
    userChallenges,
    tontines,
    tontineMembers,
    tontineMessages,
    tontineContributions,
    dashboardReports,
    spendingAnalysisCache,
    savingsTrendCache,
    narrativeReportCache,
    forecastCache,
    healthScoreHistoryCache,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String email,
      required String firstName,
      required String lastName,
      Value<String?> avatar,
      Value<int> xp,
      Value<int> level,
      Value<String> badges,
      Value<bool> isPremium,
      Value<String?> country,
      Value<String?> phone,
      Value<String> language,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String> firstName,
      Value<String> lastName,
      Value<String?> avatar,
      Value<int> xp,
      Value<int> level,
      Value<String> badges,
      Value<bool> isPremium,
      Value<String?> country,
      Value<String?> phone,
      Value<String> language,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get badges => $composableBuilder(
    column: $table.badges,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPremium => $composableBuilder(
    column: $table.isPremium,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get badges => $composableBuilder(
    column: $table.badges,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPremium => $composableBuilder(
    column: $table.isPremium,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get badges =>
      $composableBuilder(column: $table.badges, builder: (column) => column);

  GeneratedColumn<bool> get isPremium =>
      $composableBuilder(column: $table.isPremium, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> badges = const Value.absent(),
                Value<bool> isPremium = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                email: email,
                firstName: firstName,
                lastName: lastName,
                avatar: avatar,
                xp: xp,
                level: level,
                badges: badges,
                isPremium: isPremium,
                country: country,
                phone: phone,
                language: language,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                required String firstName,
                required String lastName,
                Value<String?> avatar = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> badges = const Value.absent(),
                Value<bool> isPremium = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                email: email,
                firstName: firstName,
                lastName: lastName,
                avatar: avatar,
                xp: xp,
                level: level,
                badges: badges,
                isPremium: isPremium,
                country: country,
                phone: phone,
                language: language,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      Value<String?> userId,
      required double amount,
      Value<String> currency,
      required String type,
      required String category,
      Value<String?> subcategory,
      required String description,
      Value<String?> merchant,
      Value<String?> location,
      required DateTime date,
      Value<String> status,
      Value<String?> source,
      Value<String> tags,
      Value<bool> isRecurring,
      Value<String?> recurringFrequency,
      Value<bool> isAutoCategorized,
      Value<double?> categorizationConfidence,
      Value<String?> receipt,
      Value<String?> linkedGoalId,
      Value<String?> metadata,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<double> amount,
      Value<String> currency,
      Value<String> type,
      Value<String> category,
      Value<String?> subcategory,
      Value<String> description,
      Value<String?> merchant,
      Value<String?> location,
      Value<DateTime> date,
      Value<String> status,
      Value<String?> source,
      Value<String> tags,
      Value<bool> isRecurring,
      Value<String?> recurringFrequency,
      Value<bool> isAutoCategorized,
      Value<double?> categorizationConfidence,
      Value<String?> receipt,
      Value<String?> linkedGoalId,
      Value<String?> metadata,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurringFrequency => $composableBuilder(
    column: $table.recurringFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAutoCategorized => $composableBuilder(
    column: $table.isAutoCategorized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get categorizationConfidence => $composableBuilder(
    column: $table.categorizationConfidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receipt => $composableBuilder(
    column: $table.receipt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedGoalId => $composableBuilder(
    column: $table.linkedGoalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurringFrequency => $composableBuilder(
    column: $table.recurringFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAutoCategorized => $composableBuilder(
    column: $table.isAutoCategorized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get categorizationConfidence => $composableBuilder(
    column: $table.categorizationConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receipt => $composableBuilder(
    column: $table.receipt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedGoalId => $composableBuilder(
    column: $table.linkedGoalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurringFrequency => $composableBuilder(
    column: $table.recurringFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAutoCategorized => $composableBuilder(
    column: $table.isAutoCategorized,
    builder: (column) => column,
  );

  GeneratedColumn<double> get categorizationConfidence => $composableBuilder(
    column: $table.categorizationConfidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receipt =>
      $composableBuilder(column: $table.receipt, builder: (column) => column);

  GeneratedColumn<String> get linkedGoalId => $composableBuilder(
    column: $table.linkedGoalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            Transaction,
            BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
          ),
          Transaction,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> subcategory = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> merchant = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<bool> isRecurring = const Value.absent(),
                Value<String?> recurringFrequency = const Value.absent(),
                Value<bool> isAutoCategorized = const Value.absent(),
                Value<double?> categorizationConfidence = const Value.absent(),
                Value<String?> receipt = const Value.absent(),
                Value<String?> linkedGoalId = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                userId: userId,
                amount: amount,
                currency: currency,
                type: type,
                category: category,
                subcategory: subcategory,
                description: description,
                merchant: merchant,
                location: location,
                date: date,
                status: status,
                source: source,
                tags: tags,
                isRecurring: isRecurring,
                recurringFrequency: recurringFrequency,
                isAutoCategorized: isAutoCategorized,
                categorizationConfidence: categorizationConfidence,
                receipt: receipt,
                linkedGoalId: linkedGoalId,
                metadata: metadata,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                required double amount,
                Value<String> currency = const Value.absent(),
                required String type,
                required String category,
                Value<String?> subcategory = const Value.absent(),
                required String description,
                Value<String?> merchant = const Value.absent(),
                Value<String?> location = const Value.absent(),
                required DateTime date,
                Value<String> status = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<bool> isRecurring = const Value.absent(),
                Value<String?> recurringFrequency = const Value.absent(),
                Value<bool> isAutoCategorized = const Value.absent(),
                Value<double?> categorizationConfidence = const Value.absent(),
                Value<String?> receipt = const Value.absent(),
                Value<String?> linkedGoalId = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                userId: userId,
                amount: amount,
                currency: currency,
                type: type,
                category: category,
                subcategory: subcategory,
                description: description,
                merchant: merchant,
                location: location,
                date: date,
                status: status,
                source: source,
                tags: tags,
                isRecurring: isRecurring,
                recurringFrequency: recurringFrequency,
                isAutoCategorized: isAutoCategorized,
                categorizationConfidence: categorizationConfidence,
                receipt: receipt,
                linkedGoalId: linkedGoalId,
                metadata: metadata,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        Transaction,
        BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
      ),
      Transaction,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      required String id,
      required String period,
      required String categories,
      required double totalAllocated,
      required double totalSpent,
      Value<String> status,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<String> id,
      Value<String> period,
      Value<String> categories,
      Value<double> totalAllocated,
      Value<double> totalSpent,
      Value<String> status,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAllocated => $composableBuilder(
    column: $table.totalAllocated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalSpent => $composableBuilder(
    column: $table.totalSpent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAllocated => $composableBuilder(
    column: $table.totalAllocated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalSpent => $composableBuilder(
    column: $table.totalSpent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<String> get categories => $composableBuilder(
    column: $table.categories,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAllocated => $composableBuilder(
    column: $table.totalAllocated,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalSpent => $composableBuilder(
    column: $table.totalSpent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          Budget,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
          Budget,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<String> categories = const Value.absent(),
                Value<double> totalAllocated = const Value.absent(),
                Value<double> totalSpent = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                period: period,
                categories: categories,
                totalAllocated: totalAllocated,
                totalSpent: totalSpent,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String period,
                required String categories,
                required double totalAllocated,
                required double totalSpent,
                Value<String> status = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                period: period,
                categories: categories,
                totalAllocated: totalAllocated,
                totalSpent: totalSpent,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      Budget,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
      Budget,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableCreateCompanionBuilder =
    GoalsCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<String?> emoji,
      Value<String> type,
      required double targetAmount,
      required double currentAmount,
      Value<String> currency,
      required DateTime deadline,
      Value<String?> category,
      Value<String> status,
      Value<String?> strategy,
      Value<String?> autoSaveRules,
      Value<bool> isShared,
      Value<String> participants,
      Value<String?> image,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$GoalsTableUpdateCompanionBuilder =
    GoalsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String?> emoji,
      Value<String> type,
      Value<double> targetAmount,
      Value<double> currentAmount,
      Value<String> currency,
      Value<DateTime> deadline,
      Value<String?> category,
      Value<String> status,
      Value<String?> strategy,
      Value<String?> autoSaveRules,
      Value<bool> isShared,
      Value<String> participants,
      Value<String?> image,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strategy => $composableBuilder(
    column: $table.strategy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get autoSaveRules => $composableBuilder(
    column: $table.autoSaveRules,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isShared => $composableBuilder(
    column: $table.isShared,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get participants => $composableBuilder(
    column: $table.participants,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strategy => $composableBuilder(
    column: $table.strategy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get autoSaveRules => $composableBuilder(
    column: $table.autoSaveRules,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isShared => $composableBuilder(
    column: $table.isShared,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get participants => $composableBuilder(
    column: $table.participants,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get strategy =>
      $composableBuilder(column: $table.strategy, builder: (column) => column);

  GeneratedColumn<String> get autoSaveRules => $composableBuilder(
    column: $table.autoSaveRules,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isShared =>
      $composableBuilder(column: $table.isShared, builder: (column) => column);

  GeneratedColumn<String> get participants => $composableBuilder(
    column: $table.participants,
    builder: (column) => column,
  );

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          Goal,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
          Goal,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> emoji = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> targetAmount = const Value.absent(),
                Value<double> currentAmount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> deadline = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> strategy = const Value.absent(),
                Value<String?> autoSaveRules = const Value.absent(),
                Value<bool> isShared = const Value.absent(),
                Value<String> participants = const Value.absent(),
                Value<String?> image = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                name: name,
                description: description,
                emoji: emoji,
                type: type,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                currency: currency,
                deadline: deadline,
                category: category,
                status: status,
                strategy: strategy,
                autoSaveRules: autoSaveRules,
                isShared: isShared,
                participants: participants,
                image: image,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> emoji = const Value.absent(),
                Value<String> type = const Value.absent(),
                required double targetAmount,
                required double currentAmount,
                Value<String> currency = const Value.absent(),
                required DateTime deadline,
                Value<String?> category = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> strategy = const Value.absent(),
                Value<String?> autoSaveRules = const Value.absent(),
                Value<bool> isShared = const Value.absent(),
                Value<String> participants = const Value.absent(),
                Value<String?> image = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                name: name,
                description: description,
                emoji: emoji,
                type: type,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                currency: currency,
                deadline: deadline,
                category: category,
                status: status,
                strategy: strategy,
                autoSaveRules: autoSaveRules,
                isShared: isShared,
                participants: participants,
                image: image,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      Goal,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
      Goal,
      PrefetchHooks Function()
    >;
typedef $$ChallengesTableCreateCompanionBuilder =
    ChallengesCompanion Function({
      required String id,
      required String title,
      required String description,
      required String type,
      Value<double?> targetValue,
      required double currentValue,
      required int points,
      required DateTime startDate,
      required DateTime endDate,
      Value<String> difficulty,
      Value<int> durationDays,
      Value<String?> icon,
      Value<bool> isCompleted,
      Value<String> participants,
      Value<String?> category,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$ChallengesTableUpdateCompanionBuilder =
    ChallengesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String> type,
      Value<double?> targetValue,
      Value<double> currentValue,
      Value<int> points,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<String> difficulty,
      Value<int> durationDays,
      Value<String?> icon,
      Value<bool> isCompleted,
      Value<String> participants,
      Value<String?> category,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$ChallengesTableFilterComposer
    extends Composer<_$AppDatabase, $ChallengesTable> {
  $$ChallengesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationDays => $composableBuilder(
    column: $table.durationDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get participants => $composableBuilder(
    column: $table.participants,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChallengesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChallengesTable> {
  $$ChallengesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationDays => $composableBuilder(
    column: $table.durationDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get participants => $composableBuilder(
    column: $table.participants,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChallengesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChallengesTable> {
  $$ChallengesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationDays => $composableBuilder(
    column: $table.durationDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get participants => $composableBuilder(
    column: $table.participants,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ChallengesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChallengesTable,
          Challenge,
          $$ChallengesTableFilterComposer,
          $$ChallengesTableOrderingComposer,
          $$ChallengesTableAnnotationComposer,
          $$ChallengesTableCreateCompanionBuilder,
          $$ChallengesTableUpdateCompanionBuilder,
          (
            Challenge,
            BaseReferences<_$AppDatabase, $ChallengesTable, Challenge>,
          ),
          Challenge,
          PrefetchHooks Function()
        > {
  $$ChallengesTableTableManager(_$AppDatabase db, $ChallengesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChallengesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChallengesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChallengesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double?> targetValue = const Value.absent(),
                Value<double> currentValue = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<int> durationDays = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String> participants = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChallengesCompanion(
                id: id,
                title: title,
                description: description,
                type: type,
                targetValue: targetValue,
                currentValue: currentValue,
                points: points,
                startDate: startDate,
                endDate: endDate,
                difficulty: difficulty,
                durationDays: durationDays,
                icon: icon,
                isCompleted: isCompleted,
                participants: participants,
                category: category,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required String type,
                Value<double?> targetValue = const Value.absent(),
                required double currentValue,
                required int points,
                required DateTime startDate,
                required DateTime endDate,
                Value<String> difficulty = const Value.absent(),
                Value<int> durationDays = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String> participants = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChallengesCompanion.insert(
                id: id,
                title: title,
                description: description,
                type: type,
                targetValue: targetValue,
                currentValue: currentValue,
                points: points,
                startDate: startDate,
                endDate: endDate,
                difficulty: difficulty,
                durationDays: durationDays,
                icon: icon,
                isCompleted: isCompleted,
                participants: participants,
                category: category,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChallengesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChallengesTable,
      Challenge,
      $$ChallengesTableFilterComposer,
      $$ChallengesTableOrderingComposer,
      $$ChallengesTableAnnotationComposer,
      $$ChallengesTableCreateCompanionBuilder,
      $$ChallengesTableUpdateCompanionBuilder,
      (Challenge, BaseReferences<_$AppDatabase, $ChallengesTable, Challenge>),
      Challenge,
      PrefetchHooks Function()
    >;
typedef $$ChatMessagesTableCreateCompanionBuilder =
    ChatMessagesCompanion Function({
      required String id,
      required String content,
      required String sender,
      required DateTime timestamp,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$ChatMessagesTableUpdateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<String> id,
      Value<String> content,
      Value<String> sender,
      Value<DateTime> timestamp,
      Value<String> status,
      Value<int> rowid,
    });

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$ChatMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatMessagesTable,
          ChatMessage,
          $$ChatMessagesTableFilterComposer,
          $$ChatMessagesTableOrderingComposer,
          $$ChatMessagesTableAnnotationComposer,
          $$ChatMessagesTableCreateCompanionBuilder,
          $$ChatMessagesTableUpdateCompanionBuilder,
          (
            ChatMessage,
            BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage>,
          ),
          ChatMessage,
          PrefetchHooks Function()
        > {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> sender = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatMessagesCompanion(
                id: id,
                content: content,
                sender: sender,
                timestamp: timestamp,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String content,
                required String sender,
                required DateTime timestamp,
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatMessagesCompanion.insert(
                id: id,
                content: content,
                sender: sender,
                timestamp: timestamp,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatMessagesTable,
      ChatMessage,
      $$ChatMessagesTableFilterComposer,
      $$ChatMessagesTableOrderingComposer,
      $$ChatMessagesTableAnnotationComposer,
      $$ChatMessagesTableCreateCompanionBuilder,
      $$ChatMessagesTableUpdateCompanionBuilder,
      (
        ChatMessage,
        BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage>,
      ),
      ChatMessage,
      PrefetchHooks Function()
    >;
typedef $$InvestmentsTableCreateCompanionBuilder =
    InvestmentsCompanion Function({
      required String id,
      required String name,
      required String type,
      required double initialAmount,
      required double currentAmount,
      Value<String> currency,
      Value<String> status,
      Value<String> history,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$InvestmentsTableUpdateCompanionBuilder =
    InvestmentsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<double> initialAmount,
      Value<double> currentAmount,
      Value<String> currency,
      Value<String> status,
      Value<String> history,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$InvestmentsTableFilterComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get initialAmount => $composableBuilder(
    column: $table.initialAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get history => $composableBuilder(
    column: $table.history,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InvestmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get initialAmount => $composableBuilder(
    column: $table.initialAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get history => $composableBuilder(
    column: $table.history,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InvestmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get initialAmount => $composableBuilder(
    column: $table.initialAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get history =>
      $composableBuilder(column: $table.history, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InvestmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvestmentsTable,
          Investment,
          $$InvestmentsTableFilterComposer,
          $$InvestmentsTableOrderingComposer,
          $$InvestmentsTableAnnotationComposer,
          $$InvestmentsTableCreateCompanionBuilder,
          $$InvestmentsTableUpdateCompanionBuilder,
          (
            Investment,
            BaseReferences<_$AppDatabase, $InvestmentsTable, Investment>,
          ),
          Investment,
          PrefetchHooks Function()
        > {
  $$InvestmentsTableTableManager(_$AppDatabase db, $InvestmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvestmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvestmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvestmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> initialAmount = const Value.absent(),
                Value<double> currentAmount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> history = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvestmentsCompanion(
                id: id,
                name: name,
                type: type,
                initialAmount: initialAmount,
                currentAmount: currentAmount,
                currency: currency,
                status: status,
                history: history,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                required double initialAmount,
                required double currentAmount,
                Value<String> currency = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> history = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvestmentsCompanion.insert(
                id: id,
                name: name,
                type: type,
                initialAmount: initialAmount,
                currentAmount: currentAmount,
                currency: currency,
                status: status,
                history: history,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InvestmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvestmentsTable,
      Investment,
      $$InvestmentsTableFilterComposer,
      $$InvestmentsTableOrderingComposer,
      $$InvestmentsTableAnnotationComposer,
      $$InvestmentsTableCreateCompanionBuilder,
      $$InvestmentsTableUpdateCompanionBuilder,
      (
        Investment,
        BaseReferences<_$AppDatabase, $InvestmentsTable, Investment>,
      ),
      Investment,
      PrefetchHooks Function()
    >;
typedef $$SyncRequestsTableCreateCompanionBuilder =
    SyncRequestsCompanion Function({
      Value<int> id,
      required String table,
      required String action,
      required String payload,
      Value<DateTime> createdAt,
    });
typedef $$SyncRequestsTableUpdateCompanionBuilder =
    SyncRequestsCompanion Function({
      Value<int> id,
      Value<String> table,
      Value<String> action,
      Value<String> payload,
      Value<DateTime> createdAt,
    });

class $$SyncRequestsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncRequestsTable> {
  $$SyncRequestsTableFilterComposer({
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

  ColumnFilters<String> get table => $composableBuilder(
    column: $table.table,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncRequestsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncRequestsTable> {
  $$SyncRequestsTableOrderingComposer({
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

  ColumnOrderings<String> get table => $composableBuilder(
    column: $table.table,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncRequestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncRequestsTable> {
  $$SyncRequestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get table =>
      $composableBuilder(column: $table.table, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncRequestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncRequestsTable,
          SyncRequest,
          $$SyncRequestsTableFilterComposer,
          $$SyncRequestsTableOrderingComposer,
          $$SyncRequestsTableAnnotationComposer,
          $$SyncRequestsTableCreateCompanionBuilder,
          $$SyncRequestsTableUpdateCompanionBuilder,
          (
            SyncRequest,
            BaseReferences<_$AppDatabase, $SyncRequestsTable, SyncRequest>,
          ),
          SyncRequest,
          PrefetchHooks Function()
        > {
  $$SyncRequestsTableTableManager(_$AppDatabase db, $SyncRequestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncRequestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncRequestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncRequestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> table = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncRequestsCompanion(
                id: id,
                table: table,
                action: action,
                payload: payload,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String table,
                required String action,
                required String payload,
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncRequestsCompanion.insert(
                id: id,
                table: table,
                action: action,
                payload: payload,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncRequestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncRequestsTable,
      SyncRequest,
      $$SyncRequestsTableFilterComposer,
      $$SyncRequestsTableOrderingComposer,
      $$SyncRequestsTableAnnotationComposer,
      $$SyncRequestsTableCreateCompanionBuilder,
      $$SyncRequestsTableUpdateCompanionBuilder,
      (
        SyncRequest,
        BaseReferences<_$AppDatabase, $SyncRequestsTable, SyncRequest>,
      ),
      SyncRequest,
      PrefetchHooks Function()
    >;
typedef $$UserSubscriptionsTableCreateCompanionBuilder =
    UserSubscriptionsCompanion Function({
      required String id,
      required String name,
      Value<String?> provider,
      required double amount,
      Value<String> currency,
      required String frequency,
      Value<String?> category,
      Value<String> status,
      required DateTime nextBillingDate,
      Value<DateTime?> trialEndDate,
      Value<bool> remindMe,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$UserSubscriptionsTableUpdateCompanionBuilder =
    UserSubscriptionsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> provider,
      Value<double> amount,
      Value<String> currency,
      Value<String> frequency,
      Value<String?> category,
      Value<String> status,
      Value<DateTime> nextBillingDate,
      Value<DateTime?> trialEndDate,
      Value<bool> remindMe,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$UserSubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSubscriptionsTable> {
  $$UserSubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get trialEndDate => $composableBuilder(
    column: $table.trialEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remindMe => $composableBuilder(
    column: $table.remindMe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSubscriptionsTable> {
  $$UserSubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get trialEndDate => $composableBuilder(
    column: $table.trialEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remindMe => $composableBuilder(
    column: $table.remindMe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSubscriptionsTable> {
  $$UserSubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get trialEndDate => $composableBuilder(
    column: $table.trialEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get remindMe =>
      $composableBuilder(column: $table.remindMe, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserSubscriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSubscriptionsTable,
          UserSubscription,
          $$UserSubscriptionsTableFilterComposer,
          $$UserSubscriptionsTableOrderingComposer,
          $$UserSubscriptionsTableAnnotationComposer,
          $$UserSubscriptionsTableCreateCompanionBuilder,
          $$UserSubscriptionsTableUpdateCompanionBuilder,
          (
            UserSubscription,
            BaseReferences<
              _$AppDatabase,
              $UserSubscriptionsTable,
              UserSubscription
            >,
          ),
          UserSubscription,
          PrefetchHooks Function()
        > {
  $$UserSubscriptionsTableTableManager(
    _$AppDatabase db,
    $UserSubscriptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSubscriptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> provider = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> nextBillingDate = const Value.absent(),
                Value<DateTime?> trialEndDate = const Value.absent(),
                Value<bool> remindMe = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSubscriptionsCompanion(
                id: id,
                name: name,
                provider: provider,
                amount: amount,
                currency: currency,
                frequency: frequency,
                category: category,
                status: status,
                nextBillingDate: nextBillingDate,
                trialEndDate: trialEndDate,
                remindMe: remindMe,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> provider = const Value.absent(),
                required double amount,
                Value<String> currency = const Value.absent(),
                required String frequency,
                Value<String?> category = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime nextBillingDate,
                Value<DateTime?> trialEndDate = const Value.absent(),
                Value<bool> remindMe = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSubscriptionsCompanion.insert(
                id: id,
                name: name,
                provider: provider,
                amount: amount,
                currency: currency,
                frequency: frequency,
                category: category,
                status: status,
                nextBillingDate: nextBillingDate,
                trialEndDate: trialEndDate,
                remindMe: remindMe,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSubscriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSubscriptionsTable,
      UserSubscription,
      $$UserSubscriptionsTableFilterComposer,
      $$UserSubscriptionsTableOrderingComposer,
      $$UserSubscriptionsTableAnnotationComposer,
      $$UserSubscriptionsTableCreateCompanionBuilder,
      $$UserSubscriptionsTableUpdateCompanionBuilder,
      (
        UserSubscription,
        BaseReferences<
          _$AppDatabase,
          $UserSubscriptionsTable,
          UserSubscription
        >,
      ),
      UserSubscription,
      PrefetchHooks Function()
    >;
typedef $$UserChallengesTableCreateCompanionBuilder =
    UserChallengesCompanion Function({
      required String id,
      Value<String> status,
      Value<double> progress,
      Value<double> currentValue,
      Value<String?> challengeData,
      Value<String?> weeks,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$UserChallengesTableUpdateCompanionBuilder =
    UserChallengesCompanion Function({
      Value<String> id,
      Value<String> status,
      Value<double> progress,
      Value<double> currentValue,
      Value<String?> challengeData,
      Value<String?> weeks,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$UserChallengesTableFilterComposer
    extends Composer<_$AppDatabase, $UserChallengesTable> {
  $$UserChallengesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get challengeData => $composableBuilder(
    column: $table.challengeData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weeks => $composableBuilder(
    column: $table.weeks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserChallengesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserChallengesTable> {
  $$UserChallengesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get challengeData => $composableBuilder(
    column: $table.challengeData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weeks => $composableBuilder(
    column: $table.weeks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserChallengesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserChallengesTable> {
  $$UserChallengesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get challengeData => $composableBuilder(
    column: $table.challengeData,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weeks =>
      $composableBuilder(column: $table.weeks, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserChallengesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserChallengesTable,
          UserChallenge,
          $$UserChallengesTableFilterComposer,
          $$UserChallengesTableOrderingComposer,
          $$UserChallengesTableAnnotationComposer,
          $$UserChallengesTableCreateCompanionBuilder,
          $$UserChallengesTableUpdateCompanionBuilder,
          (
            UserChallenge,
            BaseReferences<_$AppDatabase, $UserChallengesTable, UserChallenge>,
          ),
          UserChallenge,
          PrefetchHooks Function()
        > {
  $$UserChallengesTableTableManager(
    _$AppDatabase db,
    $UserChallengesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserChallengesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserChallengesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserChallengesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<double> currentValue = const Value.absent(),
                Value<String?> challengeData = const Value.absent(),
                Value<String?> weeks = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserChallengesCompanion(
                id: id,
                status: status,
                progress: progress,
                currentValue: currentValue,
                challengeData: challengeData,
                weeks: weeks,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> status = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<double> currentValue = const Value.absent(),
                Value<String?> challengeData = const Value.absent(),
                Value<String?> weeks = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserChallengesCompanion.insert(
                id: id,
                status: status,
                progress: progress,
                currentValue: currentValue,
                challengeData: challengeData,
                weeks: weeks,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserChallengesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserChallengesTable,
      UserChallenge,
      $$UserChallengesTableFilterComposer,
      $$UserChallengesTableOrderingComposer,
      $$UserChallengesTableAnnotationComposer,
      $$UserChallengesTableCreateCompanionBuilder,
      $$UserChallengesTableUpdateCompanionBuilder,
      (
        UserChallenge,
        BaseReferences<_$AppDatabase, $UserChallengesTable, UserChallenge>,
      ),
      UserChallenge,
      PrefetchHooks Function()
    >;
typedef $$TontinesTableCreateCompanionBuilder =
    TontinesCompanion Function({
      required String id,
      required String name,
      required String frequency,
      required double contributionAmount,
      required int totalParts,
      Value<String> currency,
      Value<String> status,
      required String creatorId,
      Value<String?> inviteCode,
      Value<int> currentTurn,
      Value<DateTime?> startDate,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<String?> rotationMode,
      Value<String?> validationMode,
      Value<String?> sanctions,
      Value<String?> socialFund,
      Value<String?> escrowDetails,
      Value<bool?> autoRenew,
      Value<bool?> rulesAcceptedByAll,
      Value<String?> extraData,
      Value<int> rowid,
    });
typedef $$TontinesTableUpdateCompanionBuilder =
    TontinesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> frequency,
      Value<double> contributionAmount,
      Value<int> totalParts,
      Value<String> currency,
      Value<String> status,
      Value<String> creatorId,
      Value<String?> inviteCode,
      Value<int> currentTurn,
      Value<DateTime?> startDate,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<String?> rotationMode,
      Value<String?> validationMode,
      Value<String?> sanctions,
      Value<String?> socialFund,
      Value<String?> escrowDetails,
      Value<bool?> autoRenew,
      Value<bool?> rulesAcceptedByAll,
      Value<String?> extraData,
      Value<int> rowid,
    });

class $$TontinesTableFilterComposer
    extends Composer<_$AppDatabase, $TontinesTable> {
  $$TontinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get contributionAmount => $composableBuilder(
    column: $table.contributionAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalParts => $composableBuilder(
    column: $table.totalParts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creatorId => $composableBuilder(
    column: $table.creatorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inviteCode => $composableBuilder(
    column: $table.inviteCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentTurn => $composableBuilder(
    column: $table.currentTurn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rotationMode => $composableBuilder(
    column: $table.rotationMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validationMode => $composableBuilder(
    column: $table.validationMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sanctions => $composableBuilder(
    column: $table.sanctions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get socialFund => $composableBuilder(
    column: $table.socialFund,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get escrowDetails => $composableBuilder(
    column: $table.escrowDetails,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoRenew => $composableBuilder(
    column: $table.autoRenew,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rulesAcceptedByAll => $composableBuilder(
    column: $table.rulesAcceptedByAll,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extraData => $composableBuilder(
    column: $table.extraData,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TontinesTableOrderingComposer
    extends Composer<_$AppDatabase, $TontinesTable> {
  $$TontinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get contributionAmount => $composableBuilder(
    column: $table.contributionAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalParts => $composableBuilder(
    column: $table.totalParts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creatorId => $composableBuilder(
    column: $table.creatorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inviteCode => $composableBuilder(
    column: $table.inviteCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentTurn => $composableBuilder(
    column: $table.currentTurn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rotationMode => $composableBuilder(
    column: $table.rotationMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validationMode => $composableBuilder(
    column: $table.validationMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sanctions => $composableBuilder(
    column: $table.sanctions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get socialFund => $composableBuilder(
    column: $table.socialFund,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get escrowDetails => $composableBuilder(
    column: $table.escrowDetails,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoRenew => $composableBuilder(
    column: $table.autoRenew,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rulesAcceptedByAll => $composableBuilder(
    column: $table.rulesAcceptedByAll,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extraData => $composableBuilder(
    column: $table.extraData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TontinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TontinesTable> {
  $$TontinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<double> get contributionAmount => $composableBuilder(
    column: $table.contributionAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalParts => $composableBuilder(
    column: $table.totalParts,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get creatorId =>
      $composableBuilder(column: $table.creatorId, builder: (column) => column);

  GeneratedColumn<String> get inviteCode => $composableBuilder(
    column: $table.inviteCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentTurn => $composableBuilder(
    column: $table.currentTurn,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get rotationMode => $composableBuilder(
    column: $table.rotationMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get validationMode => $composableBuilder(
    column: $table.validationMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sanctions =>
      $composableBuilder(column: $table.sanctions, builder: (column) => column);

  GeneratedColumn<String> get socialFund => $composableBuilder(
    column: $table.socialFund,
    builder: (column) => column,
  );

  GeneratedColumn<String> get escrowDetails => $composableBuilder(
    column: $table.escrowDetails,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoRenew =>
      $composableBuilder(column: $table.autoRenew, builder: (column) => column);

  GeneratedColumn<bool> get rulesAcceptedByAll => $composableBuilder(
    column: $table.rulesAcceptedByAll,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extraData =>
      $composableBuilder(column: $table.extraData, builder: (column) => column);
}

class $$TontinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TontinesTable,
          Tontine,
          $$TontinesTableFilterComposer,
          $$TontinesTableOrderingComposer,
          $$TontinesTableAnnotationComposer,
          $$TontinesTableCreateCompanionBuilder,
          $$TontinesTableUpdateCompanionBuilder,
          (Tontine, BaseReferences<_$AppDatabase, $TontinesTable, Tontine>),
          Tontine,
          PrefetchHooks Function()
        > {
  $$TontinesTableTableManager(_$AppDatabase db, $TontinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TontinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TontinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TontinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<double> contributionAmount = const Value.absent(),
                Value<int> totalParts = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> creatorId = const Value.absent(),
                Value<String?> inviteCode = const Value.absent(),
                Value<int> currentTurn = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String?> rotationMode = const Value.absent(),
                Value<String?> validationMode = const Value.absent(),
                Value<String?> sanctions = const Value.absent(),
                Value<String?> socialFund = const Value.absent(),
                Value<String?> escrowDetails = const Value.absent(),
                Value<bool?> autoRenew = const Value.absent(),
                Value<bool?> rulesAcceptedByAll = const Value.absent(),
                Value<String?> extraData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TontinesCompanion(
                id: id,
                name: name,
                frequency: frequency,
                contributionAmount: contributionAmount,
                totalParts: totalParts,
                currency: currency,
                status: status,
                creatorId: creatorId,
                inviteCode: inviteCode,
                currentTurn: currentTurn,
                startDate: startDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rotationMode: rotationMode,
                validationMode: validationMode,
                sanctions: sanctions,
                socialFund: socialFund,
                escrowDetails: escrowDetails,
                autoRenew: autoRenew,
                rulesAcceptedByAll: rulesAcceptedByAll,
                extraData: extraData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String frequency,
                required double contributionAmount,
                required int totalParts,
                Value<String> currency = const Value.absent(),
                Value<String> status = const Value.absent(),
                required String creatorId,
                Value<String?> inviteCode = const Value.absent(),
                Value<int> currentTurn = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String?> rotationMode = const Value.absent(),
                Value<String?> validationMode = const Value.absent(),
                Value<String?> sanctions = const Value.absent(),
                Value<String?> socialFund = const Value.absent(),
                Value<String?> escrowDetails = const Value.absent(),
                Value<bool?> autoRenew = const Value.absent(),
                Value<bool?> rulesAcceptedByAll = const Value.absent(),
                Value<String?> extraData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TontinesCompanion.insert(
                id: id,
                name: name,
                frequency: frequency,
                contributionAmount: contributionAmount,
                totalParts: totalParts,
                currency: currency,
                status: status,
                creatorId: creatorId,
                inviteCode: inviteCode,
                currentTurn: currentTurn,
                startDate: startDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rotationMode: rotationMode,
                validationMode: validationMode,
                sanctions: sanctions,
                socialFund: socialFund,
                escrowDetails: escrowDetails,
                autoRenew: autoRenew,
                rulesAcceptedByAll: rulesAcceptedByAll,
                extraData: extraData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TontinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TontinesTable,
      Tontine,
      $$TontinesTableFilterComposer,
      $$TontinesTableOrderingComposer,
      $$TontinesTableAnnotationComposer,
      $$TontinesTableCreateCompanionBuilder,
      $$TontinesTableUpdateCompanionBuilder,
      (Tontine, BaseReferences<_$AppDatabase, $TontinesTable, Tontine>),
      Tontine,
      PrefetchHooks Function()
    >;
typedef $$TontineMembersTableCreateCompanionBuilder =
    TontineMembersCompanion Function({
      required String id,
      required String tontineId,
      required String userId,
      required String displayName,
      Value<int> parts,
      Value<double> trustScore,
      Value<bool> hasPaidSocialFund,
      Value<String?> payoutDetails,
      Value<int> rowid,
    });
typedef $$TontineMembersTableUpdateCompanionBuilder =
    TontineMembersCompanion Function({
      Value<String> id,
      Value<String> tontineId,
      Value<String> userId,
      Value<String> displayName,
      Value<int> parts,
      Value<double> trustScore,
      Value<bool> hasPaidSocialFund,
      Value<String?> payoutDetails,
      Value<int> rowid,
    });

class $$TontineMembersTableFilterComposer
    extends Composer<_$AppDatabase, $TontineMembersTable> {
  $$TontineMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tontineId => $composableBuilder(
    column: $table.tontineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parts => $composableBuilder(
    column: $table.parts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get trustScore => $composableBuilder(
    column: $table.trustScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasPaidSocialFund => $composableBuilder(
    column: $table.hasPaidSocialFund,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payoutDetails => $composableBuilder(
    column: $table.payoutDetails,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TontineMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $TontineMembersTable> {
  $$TontineMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tontineId => $composableBuilder(
    column: $table.tontineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parts => $composableBuilder(
    column: $table.parts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get trustScore => $composableBuilder(
    column: $table.trustScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasPaidSocialFund => $composableBuilder(
    column: $table.hasPaidSocialFund,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payoutDetails => $composableBuilder(
    column: $table.payoutDetails,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TontineMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TontineMembersTable> {
  $$TontineMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tontineId =>
      $composableBuilder(column: $table.tontineId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get parts =>
      $composableBuilder(column: $table.parts, builder: (column) => column);

  GeneratedColumn<double> get trustScore => $composableBuilder(
    column: $table.trustScore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasPaidSocialFund => $composableBuilder(
    column: $table.hasPaidSocialFund,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payoutDetails => $composableBuilder(
    column: $table.payoutDetails,
    builder: (column) => column,
  );
}

class $$TontineMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TontineMembersTable,
          TontineMember,
          $$TontineMembersTableFilterComposer,
          $$TontineMembersTableOrderingComposer,
          $$TontineMembersTableAnnotationComposer,
          $$TontineMembersTableCreateCompanionBuilder,
          $$TontineMembersTableUpdateCompanionBuilder,
          (
            TontineMember,
            BaseReferences<_$AppDatabase, $TontineMembersTable, TontineMember>,
          ),
          TontineMember,
          PrefetchHooks Function()
        > {
  $$TontineMembersTableTableManager(
    _$AppDatabase db,
    $TontineMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TontineMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TontineMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TontineMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tontineId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<int> parts = const Value.absent(),
                Value<double> trustScore = const Value.absent(),
                Value<bool> hasPaidSocialFund = const Value.absent(),
                Value<String?> payoutDetails = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TontineMembersCompanion(
                id: id,
                tontineId: tontineId,
                userId: userId,
                displayName: displayName,
                parts: parts,
                trustScore: trustScore,
                hasPaidSocialFund: hasPaidSocialFund,
                payoutDetails: payoutDetails,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tontineId,
                required String userId,
                required String displayName,
                Value<int> parts = const Value.absent(),
                Value<double> trustScore = const Value.absent(),
                Value<bool> hasPaidSocialFund = const Value.absent(),
                Value<String?> payoutDetails = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TontineMembersCompanion.insert(
                id: id,
                tontineId: tontineId,
                userId: userId,
                displayName: displayName,
                parts: parts,
                trustScore: trustScore,
                hasPaidSocialFund: hasPaidSocialFund,
                payoutDetails: payoutDetails,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TontineMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TontineMembersTable,
      TontineMember,
      $$TontineMembersTableFilterComposer,
      $$TontineMembersTableOrderingComposer,
      $$TontineMembersTableAnnotationComposer,
      $$TontineMembersTableCreateCompanionBuilder,
      $$TontineMembersTableUpdateCompanionBuilder,
      (
        TontineMember,
        BaseReferences<_$AppDatabase, $TontineMembersTable, TontineMember>,
      ),
      TontineMember,
      PrefetchHooks Function()
    >;
typedef $$TontineMessagesTableCreateCompanionBuilder =
    TontineMessagesCompanion Function({
      required String id,
      required String tontineId,
      required String senderId,
      required String content,
      Value<String> type,
      Value<String?> audioUrl,
      Value<int?> audioDuration,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TontineMessagesTableUpdateCompanionBuilder =
    TontineMessagesCompanion Function({
      Value<String> id,
      Value<String> tontineId,
      Value<String> senderId,
      Value<String> content,
      Value<String> type,
      Value<String?> audioUrl,
      Value<int?> audioDuration,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$TontineMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $TontineMessagesTable> {
  $$TontineMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tontineId => $composableBuilder(
    column: $table.tontineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get audioDuration => $composableBuilder(
    column: $table.audioDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TontineMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $TontineMessagesTable> {
  $$TontineMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tontineId => $composableBuilder(
    column: $table.tontineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get audioDuration => $composableBuilder(
    column: $table.audioDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TontineMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TontineMessagesTable> {
  $$TontineMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tontineId =>
      $composableBuilder(column: $table.tontineId, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<int> get audioDuration => $composableBuilder(
    column: $table.audioDuration,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TontineMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TontineMessagesTable,
          TontineMessage,
          $$TontineMessagesTableFilterComposer,
          $$TontineMessagesTableOrderingComposer,
          $$TontineMessagesTableAnnotationComposer,
          $$TontineMessagesTableCreateCompanionBuilder,
          $$TontineMessagesTableUpdateCompanionBuilder,
          (
            TontineMessage,
            BaseReferences<
              _$AppDatabase,
              $TontineMessagesTable,
              TontineMessage
            >,
          ),
          TontineMessage,
          PrefetchHooks Function()
        > {
  $$TontineMessagesTableTableManager(
    _$AppDatabase db,
    $TontineMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TontineMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TontineMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TontineMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tontineId = const Value.absent(),
                Value<String> senderId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int?> audioDuration = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TontineMessagesCompanion(
                id: id,
                tontineId: tontineId,
                senderId: senderId,
                content: content,
                type: type,
                audioUrl: audioUrl,
                audioDuration: audioDuration,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tontineId,
                required String senderId,
                required String content,
                Value<String> type = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int?> audioDuration = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TontineMessagesCompanion.insert(
                id: id,
                tontineId: tontineId,
                senderId: senderId,
                content: content,
                type: type,
                audioUrl: audioUrl,
                audioDuration: audioDuration,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TontineMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TontineMessagesTable,
      TontineMessage,
      $$TontineMessagesTableFilterComposer,
      $$TontineMessagesTableOrderingComposer,
      $$TontineMessagesTableAnnotationComposer,
      $$TontineMessagesTableCreateCompanionBuilder,
      $$TontineMessagesTableUpdateCompanionBuilder,
      (
        TontineMessage,
        BaseReferences<_$AppDatabase, $TontineMessagesTable, TontineMessage>,
      ),
      TontineMessage,
      PrefetchHooks Function()
    >;
typedef $$TontineContributionsTableCreateCompanionBuilder =
    TontineContributionsCompanion Function({
      required String id,
      required String tontineId,
      required String memberId,
      required int turnIndex,
      required double amountPaid,
      Value<String?> proofImage,
      Value<String> validationStatus,
      Value<String?> aiAnalysis,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TontineContributionsTableUpdateCompanionBuilder =
    TontineContributionsCompanion Function({
      Value<String> id,
      Value<String> tontineId,
      Value<String> memberId,
      Value<int> turnIndex,
      Value<double> amountPaid,
      Value<String?> proofImage,
      Value<String> validationStatus,
      Value<String?> aiAnalysis,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$TontineContributionsTableFilterComposer
    extends Composer<_$AppDatabase, $TontineContributionsTable> {
  $$TontineContributionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tontineId => $composableBuilder(
    column: $table.tontineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get turnIndex => $composableBuilder(
    column: $table.turnIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proofImage => $composableBuilder(
    column: $table.proofImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validationStatus => $composableBuilder(
    column: $table.validationStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiAnalysis => $composableBuilder(
    column: $table.aiAnalysis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TontineContributionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TontineContributionsTable> {
  $$TontineContributionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tontineId => $composableBuilder(
    column: $table.tontineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get turnIndex => $composableBuilder(
    column: $table.turnIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proofImage => $composableBuilder(
    column: $table.proofImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validationStatus => $composableBuilder(
    column: $table.validationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiAnalysis => $composableBuilder(
    column: $table.aiAnalysis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TontineContributionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TontineContributionsTable> {
  $$TontineContributionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tontineId =>
      $composableBuilder(column: $table.tontineId, builder: (column) => column);

  GeneratedColumn<String> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumn<int> get turnIndex =>
      $composableBuilder(column: $table.turnIndex, builder: (column) => column);

  GeneratedColumn<double> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get proofImage => $composableBuilder(
    column: $table.proofImage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get validationStatus => $composableBuilder(
    column: $table.validationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aiAnalysis => $composableBuilder(
    column: $table.aiAnalysis,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TontineContributionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TontineContributionsTable,
          TontineContribution,
          $$TontineContributionsTableFilterComposer,
          $$TontineContributionsTableOrderingComposer,
          $$TontineContributionsTableAnnotationComposer,
          $$TontineContributionsTableCreateCompanionBuilder,
          $$TontineContributionsTableUpdateCompanionBuilder,
          (
            TontineContribution,
            BaseReferences<
              _$AppDatabase,
              $TontineContributionsTable,
              TontineContribution
            >,
          ),
          TontineContribution,
          PrefetchHooks Function()
        > {
  $$TontineContributionsTableTableManager(
    _$AppDatabase db,
    $TontineContributionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TontineContributionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TontineContributionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TontineContributionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tontineId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<int> turnIndex = const Value.absent(),
                Value<double> amountPaid = const Value.absent(),
                Value<String?> proofImage = const Value.absent(),
                Value<String> validationStatus = const Value.absent(),
                Value<String?> aiAnalysis = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TontineContributionsCompanion(
                id: id,
                tontineId: tontineId,
                memberId: memberId,
                turnIndex: turnIndex,
                amountPaid: amountPaid,
                proofImage: proofImage,
                validationStatus: validationStatus,
                aiAnalysis: aiAnalysis,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tontineId,
                required String memberId,
                required int turnIndex,
                required double amountPaid,
                Value<String?> proofImage = const Value.absent(),
                Value<String> validationStatus = const Value.absent(),
                Value<String?> aiAnalysis = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TontineContributionsCompanion.insert(
                id: id,
                tontineId: tontineId,
                memberId: memberId,
                turnIndex: turnIndex,
                amountPaid: amountPaid,
                proofImage: proofImage,
                validationStatus: validationStatus,
                aiAnalysis: aiAnalysis,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TontineContributionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TontineContributionsTable,
      TontineContribution,
      $$TontineContributionsTableFilterComposer,
      $$TontineContributionsTableOrderingComposer,
      $$TontineContributionsTableAnnotationComposer,
      $$TontineContributionsTableCreateCompanionBuilder,
      $$TontineContributionsTableUpdateCompanionBuilder,
      (
        TontineContribution,
        BaseReferences<
          _$AppDatabase,
          $TontineContributionsTable,
          TontineContribution
        >,
      ),
      TontineContribution,
      PrefetchHooks Function()
    >;
typedef $$DashboardReportsTableCreateCompanionBuilder =
    DashboardReportsCompanion Function({
      Value<int> id,
      required double walletBalance,
      required double monthlyIncome,
      required double totalSpent,
      required double savingsRate,
      Value<String> currency,
      Value<String?> budgetHealth,
      required DateTime cachedAt,
    });
typedef $$DashboardReportsTableUpdateCompanionBuilder =
    DashboardReportsCompanion Function({
      Value<int> id,
      Value<double> walletBalance,
      Value<double> monthlyIncome,
      Value<double> totalSpent,
      Value<double> savingsRate,
      Value<String> currency,
      Value<String?> budgetHealth,
      Value<DateTime> cachedAt,
    });

class $$DashboardReportsTableFilterComposer
    extends Composer<_$AppDatabase, $DashboardReportsTable> {
  $$DashboardReportsTableFilterComposer({
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

  ColumnFilters<double> get walletBalance => $composableBuilder(
    column: $table.walletBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlyIncome => $composableBuilder(
    column: $table.monthlyIncome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalSpent => $composableBuilder(
    column: $table.totalSpent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get savingsRate => $composableBuilder(
    column: $table.savingsRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetHealth => $composableBuilder(
    column: $table.budgetHealth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DashboardReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $DashboardReportsTable> {
  $$DashboardReportsTableOrderingComposer({
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

  ColumnOrderings<double> get walletBalance => $composableBuilder(
    column: $table.walletBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlyIncome => $composableBuilder(
    column: $table.monthlyIncome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalSpent => $composableBuilder(
    column: $table.totalSpent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get savingsRate => $composableBuilder(
    column: $table.savingsRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetHealth => $composableBuilder(
    column: $table.budgetHealth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DashboardReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DashboardReportsTable> {
  $$DashboardReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get walletBalance => $composableBuilder(
    column: $table.walletBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get monthlyIncome => $composableBuilder(
    column: $table.monthlyIncome,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalSpent => $composableBuilder(
    column: $table.totalSpent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get savingsRate => $composableBuilder(
    column: $table.savingsRate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get budgetHealth => $composableBuilder(
    column: $table.budgetHealth,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$DashboardReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DashboardReportsTable,
          DashboardReport,
          $$DashboardReportsTableFilterComposer,
          $$DashboardReportsTableOrderingComposer,
          $$DashboardReportsTableAnnotationComposer,
          $$DashboardReportsTableCreateCompanionBuilder,
          $$DashboardReportsTableUpdateCompanionBuilder,
          (
            DashboardReport,
            BaseReferences<
              _$AppDatabase,
              $DashboardReportsTable,
              DashboardReport
            >,
          ),
          DashboardReport,
          PrefetchHooks Function()
        > {
  $$DashboardReportsTableTableManager(
    _$AppDatabase db,
    $DashboardReportsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DashboardReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DashboardReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DashboardReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> walletBalance = const Value.absent(),
                Value<double> monthlyIncome = const Value.absent(),
                Value<double> totalSpent = const Value.absent(),
                Value<double> savingsRate = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> budgetHealth = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => DashboardReportsCompanion(
                id: id,
                walletBalance: walletBalance,
                monthlyIncome: monthlyIncome,
                totalSpent: totalSpent,
                savingsRate: savingsRate,
                currency: currency,
                budgetHealth: budgetHealth,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double walletBalance,
                required double monthlyIncome,
                required double totalSpent,
                required double savingsRate,
                Value<String> currency = const Value.absent(),
                Value<String?> budgetHealth = const Value.absent(),
                required DateTime cachedAt,
              }) => DashboardReportsCompanion.insert(
                id: id,
                walletBalance: walletBalance,
                monthlyIncome: monthlyIncome,
                totalSpent: totalSpent,
                savingsRate: savingsRate,
                currency: currency,
                budgetHealth: budgetHealth,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DashboardReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DashboardReportsTable,
      DashboardReport,
      $$DashboardReportsTableFilterComposer,
      $$DashboardReportsTableOrderingComposer,
      $$DashboardReportsTableAnnotationComposer,
      $$DashboardReportsTableCreateCompanionBuilder,
      $$DashboardReportsTableUpdateCompanionBuilder,
      (
        DashboardReport,
        BaseReferences<_$AppDatabase, $DashboardReportsTable, DashboardReport>,
      ),
      DashboardReport,
      PrefetchHooks Function()
    >;
typedef $$SpendingAnalysisCacheTableCreateCompanionBuilder =
    SpendingAnalysisCacheCompanion Function({
      required String period,
      required String dataJson,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$SpendingAnalysisCacheTableUpdateCompanionBuilder =
    SpendingAnalysisCacheCompanion Function({
      Value<String> period,
      Value<String> dataJson,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$SpendingAnalysisCacheTableFilterComposer
    extends Composer<_$AppDatabase, $SpendingAnalysisCacheTable> {
  $$SpendingAnalysisCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SpendingAnalysisCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $SpendingAnalysisCacheTable> {
  $$SpendingAnalysisCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpendingAnalysisCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpendingAnalysisCacheTable> {
  $$SpendingAnalysisCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$SpendingAnalysisCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpendingAnalysisCacheTable,
          SpendingAnalysisCacheData,
          $$SpendingAnalysisCacheTableFilterComposer,
          $$SpendingAnalysisCacheTableOrderingComposer,
          $$SpendingAnalysisCacheTableAnnotationComposer,
          $$SpendingAnalysisCacheTableCreateCompanionBuilder,
          $$SpendingAnalysisCacheTableUpdateCompanionBuilder,
          (
            SpendingAnalysisCacheData,
            BaseReferences<
              _$AppDatabase,
              $SpendingAnalysisCacheTable,
              SpendingAnalysisCacheData
            >,
          ),
          SpendingAnalysisCacheData,
          PrefetchHooks Function()
        > {
  $$SpendingAnalysisCacheTableTableManager(
    _$AppDatabase db,
    $SpendingAnalysisCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpendingAnalysisCacheTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SpendingAnalysisCacheTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SpendingAnalysisCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> period = const Value.absent(),
                Value<String> dataJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpendingAnalysisCacheCompanion(
                period: period,
                dataJson: dataJson,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String period,
                required String dataJson,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => SpendingAnalysisCacheCompanion.insert(
                period: period,
                dataJson: dataJson,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SpendingAnalysisCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpendingAnalysisCacheTable,
      SpendingAnalysisCacheData,
      $$SpendingAnalysisCacheTableFilterComposer,
      $$SpendingAnalysisCacheTableOrderingComposer,
      $$SpendingAnalysisCacheTableAnnotationComposer,
      $$SpendingAnalysisCacheTableCreateCompanionBuilder,
      $$SpendingAnalysisCacheTableUpdateCompanionBuilder,
      (
        SpendingAnalysisCacheData,
        BaseReferences<
          _$AppDatabase,
          $SpendingAnalysisCacheTable,
          SpendingAnalysisCacheData
        >,
      ),
      SpendingAnalysisCacheData,
      PrefetchHooks Function()
    >;
typedef $$SavingsTrendCacheTableCreateCompanionBuilder =
    SavingsTrendCacheCompanion Function({
      required String period,
      required String dataJson,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$SavingsTrendCacheTableUpdateCompanionBuilder =
    SavingsTrendCacheCompanion Function({
      Value<String> period,
      Value<String> dataJson,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$SavingsTrendCacheTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsTrendCacheTable> {
  $$SavingsTrendCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsTrendCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsTrendCacheTable> {
  $$SavingsTrendCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsTrendCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsTrendCacheTable> {
  $$SavingsTrendCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$SavingsTrendCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsTrendCacheTable,
          SavingsTrendCacheData,
          $$SavingsTrendCacheTableFilterComposer,
          $$SavingsTrendCacheTableOrderingComposer,
          $$SavingsTrendCacheTableAnnotationComposer,
          $$SavingsTrendCacheTableCreateCompanionBuilder,
          $$SavingsTrendCacheTableUpdateCompanionBuilder,
          (
            SavingsTrendCacheData,
            BaseReferences<
              _$AppDatabase,
              $SavingsTrendCacheTable,
              SavingsTrendCacheData
            >,
          ),
          SavingsTrendCacheData,
          PrefetchHooks Function()
        > {
  $$SavingsTrendCacheTableTableManager(
    _$AppDatabase db,
    $SavingsTrendCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsTrendCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsTrendCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsTrendCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> period = const Value.absent(),
                Value<String> dataJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavingsTrendCacheCompanion(
                period: period,
                dataJson: dataJson,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String period,
                required String dataJson,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => SavingsTrendCacheCompanion.insert(
                period: period,
                dataJson: dataJson,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsTrendCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsTrendCacheTable,
      SavingsTrendCacheData,
      $$SavingsTrendCacheTableFilterComposer,
      $$SavingsTrendCacheTableOrderingComposer,
      $$SavingsTrendCacheTableAnnotationComposer,
      $$SavingsTrendCacheTableCreateCompanionBuilder,
      $$SavingsTrendCacheTableUpdateCompanionBuilder,
      (
        SavingsTrendCacheData,
        BaseReferences<
          _$AppDatabase,
          $SavingsTrendCacheTable,
          SavingsTrendCacheData
        >,
      ),
      SavingsTrendCacheData,
      PrefetchHooks Function()
    >;
typedef $$NarrativeReportCacheTableCreateCompanionBuilder =
    NarrativeReportCacheCompanion Function({
      Value<int> id,
      required String dataJson,
      required DateTime cachedAt,
    });
typedef $$NarrativeReportCacheTableUpdateCompanionBuilder =
    NarrativeReportCacheCompanion Function({
      Value<int> id,
      Value<String> dataJson,
      Value<DateTime> cachedAt,
    });

class $$NarrativeReportCacheTableFilterComposer
    extends Composer<_$AppDatabase, $NarrativeReportCacheTable> {
  $$NarrativeReportCacheTableFilterComposer({
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

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NarrativeReportCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $NarrativeReportCacheTable> {
  $$NarrativeReportCacheTableOrderingComposer({
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

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NarrativeReportCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $NarrativeReportCacheTable> {
  $$NarrativeReportCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$NarrativeReportCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NarrativeReportCacheTable,
          NarrativeReportCacheData,
          $$NarrativeReportCacheTableFilterComposer,
          $$NarrativeReportCacheTableOrderingComposer,
          $$NarrativeReportCacheTableAnnotationComposer,
          $$NarrativeReportCacheTableCreateCompanionBuilder,
          $$NarrativeReportCacheTableUpdateCompanionBuilder,
          (
            NarrativeReportCacheData,
            BaseReferences<
              _$AppDatabase,
              $NarrativeReportCacheTable,
              NarrativeReportCacheData
            >,
          ),
          NarrativeReportCacheData,
          PrefetchHooks Function()
        > {
  $$NarrativeReportCacheTableTableManager(
    _$AppDatabase db,
    $NarrativeReportCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NarrativeReportCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NarrativeReportCacheTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NarrativeReportCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dataJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => NarrativeReportCacheCompanion(
                id: id,
                dataJson: dataJson,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dataJson,
                required DateTime cachedAt,
              }) => NarrativeReportCacheCompanion.insert(
                id: id,
                dataJson: dataJson,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NarrativeReportCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NarrativeReportCacheTable,
      NarrativeReportCacheData,
      $$NarrativeReportCacheTableFilterComposer,
      $$NarrativeReportCacheTableOrderingComposer,
      $$NarrativeReportCacheTableAnnotationComposer,
      $$NarrativeReportCacheTableCreateCompanionBuilder,
      $$NarrativeReportCacheTableUpdateCompanionBuilder,
      (
        NarrativeReportCacheData,
        BaseReferences<
          _$AppDatabase,
          $NarrativeReportCacheTable,
          NarrativeReportCacheData
        >,
      ),
      NarrativeReportCacheData,
      PrefetchHooks Function()
    >;
typedef $$ForecastCacheTableCreateCompanionBuilder =
    ForecastCacheCompanion Function({
      Value<int> id,
      required String dataJson,
      required DateTime cachedAt,
    });
typedef $$ForecastCacheTableUpdateCompanionBuilder =
    ForecastCacheCompanion Function({
      Value<int> id,
      Value<String> dataJson,
      Value<DateTime> cachedAt,
    });

class $$ForecastCacheTableFilterComposer
    extends Composer<_$AppDatabase, $ForecastCacheTable> {
  $$ForecastCacheTableFilterComposer({
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

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ForecastCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $ForecastCacheTable> {
  $$ForecastCacheTableOrderingComposer({
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

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ForecastCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $ForecastCacheTable> {
  $$ForecastCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$ForecastCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ForecastCacheTable,
          ForecastCacheData,
          $$ForecastCacheTableFilterComposer,
          $$ForecastCacheTableOrderingComposer,
          $$ForecastCacheTableAnnotationComposer,
          $$ForecastCacheTableCreateCompanionBuilder,
          $$ForecastCacheTableUpdateCompanionBuilder,
          (
            ForecastCacheData,
            BaseReferences<
              _$AppDatabase,
              $ForecastCacheTable,
              ForecastCacheData
            >,
          ),
          ForecastCacheData,
          PrefetchHooks Function()
        > {
  $$ForecastCacheTableTableManager(_$AppDatabase db, $ForecastCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ForecastCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ForecastCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ForecastCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dataJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => ForecastCacheCompanion(
                id: id,
                dataJson: dataJson,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dataJson,
                required DateTime cachedAt,
              }) => ForecastCacheCompanion.insert(
                id: id,
                dataJson: dataJson,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ForecastCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ForecastCacheTable,
      ForecastCacheData,
      $$ForecastCacheTableFilterComposer,
      $$ForecastCacheTableOrderingComposer,
      $$ForecastCacheTableAnnotationComposer,
      $$ForecastCacheTableCreateCompanionBuilder,
      $$ForecastCacheTableUpdateCompanionBuilder,
      (
        ForecastCacheData,
        BaseReferences<_$AppDatabase, $ForecastCacheTable, ForecastCacheData>,
      ),
      ForecastCacheData,
      PrefetchHooks Function()
    >;
typedef $$HealthScoreHistoryCacheTableCreateCompanionBuilder =
    HealthScoreHistoryCacheCompanion Function({
      Value<int> id,
      required String dataJson,
      required DateTime cachedAt,
    });
typedef $$HealthScoreHistoryCacheTableUpdateCompanionBuilder =
    HealthScoreHistoryCacheCompanion Function({
      Value<int> id,
      Value<String> dataJson,
      Value<DateTime> cachedAt,
    });

class $$HealthScoreHistoryCacheTableFilterComposer
    extends Composer<_$AppDatabase, $HealthScoreHistoryCacheTable> {
  $$HealthScoreHistoryCacheTableFilterComposer({
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

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HealthScoreHistoryCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthScoreHistoryCacheTable> {
  $$HealthScoreHistoryCacheTableOrderingComposer({
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

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HealthScoreHistoryCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthScoreHistoryCacheTable> {
  $$HealthScoreHistoryCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$HealthScoreHistoryCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HealthScoreHistoryCacheTable,
          HealthScoreHistoryCacheData,
          $$HealthScoreHistoryCacheTableFilterComposer,
          $$HealthScoreHistoryCacheTableOrderingComposer,
          $$HealthScoreHistoryCacheTableAnnotationComposer,
          $$HealthScoreHistoryCacheTableCreateCompanionBuilder,
          $$HealthScoreHistoryCacheTableUpdateCompanionBuilder,
          (
            HealthScoreHistoryCacheData,
            BaseReferences<
              _$AppDatabase,
              $HealthScoreHistoryCacheTable,
              HealthScoreHistoryCacheData
            >,
          ),
          HealthScoreHistoryCacheData,
          PrefetchHooks Function()
        > {
  $$HealthScoreHistoryCacheTableTableManager(
    _$AppDatabase db,
    $HealthScoreHistoryCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthScoreHistoryCacheTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$HealthScoreHistoryCacheTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HealthScoreHistoryCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dataJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => HealthScoreHistoryCacheCompanion(
                id: id,
                dataJson: dataJson,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dataJson,
                required DateTime cachedAt,
              }) => HealthScoreHistoryCacheCompanion.insert(
                id: id,
                dataJson: dataJson,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HealthScoreHistoryCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HealthScoreHistoryCacheTable,
      HealthScoreHistoryCacheData,
      $$HealthScoreHistoryCacheTableFilterComposer,
      $$HealthScoreHistoryCacheTableOrderingComposer,
      $$HealthScoreHistoryCacheTableAnnotationComposer,
      $$HealthScoreHistoryCacheTableCreateCompanionBuilder,
      $$HealthScoreHistoryCacheTableUpdateCompanionBuilder,
      (
        HealthScoreHistoryCacheData,
        BaseReferences<
          _$AppDatabase,
          $HealthScoreHistoryCacheTable,
          HealthScoreHistoryCacheData
        >,
      ),
      HealthScoreHistoryCacheData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$ChallengesTableTableManager get challenges =>
      $$ChallengesTableTableManager(_db, _db.challenges);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
  $$InvestmentsTableTableManager get investments =>
      $$InvestmentsTableTableManager(_db, _db.investments);
  $$SyncRequestsTableTableManager get syncRequests =>
      $$SyncRequestsTableTableManager(_db, _db.syncRequests);
  $$UserSubscriptionsTableTableManager get userSubscriptions =>
      $$UserSubscriptionsTableTableManager(_db, _db.userSubscriptions);
  $$UserChallengesTableTableManager get userChallenges =>
      $$UserChallengesTableTableManager(_db, _db.userChallenges);
  $$TontinesTableTableManager get tontines =>
      $$TontinesTableTableManager(_db, _db.tontines);
  $$TontineMembersTableTableManager get tontineMembers =>
      $$TontineMembersTableTableManager(_db, _db.tontineMembers);
  $$TontineMessagesTableTableManager get tontineMessages =>
      $$TontineMessagesTableTableManager(_db, _db.tontineMessages);
  $$TontineContributionsTableTableManager get tontineContributions =>
      $$TontineContributionsTableTableManager(_db, _db.tontineContributions);
  $$DashboardReportsTableTableManager get dashboardReports =>
      $$DashboardReportsTableTableManager(_db, _db.dashboardReports);
  $$SpendingAnalysisCacheTableTableManager get spendingAnalysisCache =>
      $$SpendingAnalysisCacheTableTableManager(_db, _db.spendingAnalysisCache);
  $$SavingsTrendCacheTableTableManager get savingsTrendCache =>
      $$SavingsTrendCacheTableTableManager(_db, _db.savingsTrendCache);
  $$NarrativeReportCacheTableTableManager get narrativeReportCache =>
      $$NarrativeReportCacheTableTableManager(_db, _db.narrativeReportCache);
  $$ForecastCacheTableTableManager get forecastCache =>
      $$ForecastCacheTableTableManager(_db, _db.forecastCache);
  $$HealthScoreHistoryCacheTableTableManager get healthScoreHistoryCache =>
      $$HealthScoreHistoryCacheTableTableManager(
        _db,
        _db.healthScoreHistoryCache,
      );
}
