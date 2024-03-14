import 'dart:io';

// Class untuk representasi Hero
class Hero {
  String _name;
  int _health;
  int _attack;
  int _defense;

  Hero(this._name, this._health, this._attack, this._defense);

  String get name => _name;

  int get health => _health;

  int get attack => _attack;

  int get defense => _defense;

  set health(int value) {
    _health = value;
  }

  Future<void> serang(Mob enemy) async {
    print('$_name menyerang ${enemy.name}!');
    await Future.delayed(Duration(seconds: 1));
    enemy.receiveDamage(_attack);
  }

  void receiveDamage(int damage) {
    if (_defense >= damage) {
      print('$_name menerima 0 damage! (Defense Hero melindungi)');
    } else {
      _health -= (damage - _defense);
      print('$_name menerima ${damage - _defense} damage!');
    }

    if (_health <= 0) {
      print('$_name telah dikalahkan!');
    }
  }
}

// Class untuk representasi Mobs (musuh)
class Mob {
  String _name;
  int _health;
  int _attack;

  Mob(this._name, this._health, this._attack);

  String get name => _name;

  int get health => _health;

  int get attack => _attack;

  set health(int value) {
    _health = value;
  }

  Future<void> serang(Hero enemy) async {
    print('$_name menyerang ${enemy.name}!');
    await Future.delayed(Duration(seconds: 1));
    enemy.receiveDamage(_attack);
  }

  void receiveDamage(int damage) {
    print('$_name menerima $damage damage!');
    _health -= damage;
    if (_health <= 0) {
      print('$_name telah dikalahkan!');
    }
  }
}

void main() {
  var heroList = [
    Hero('Warrior', 120, 12, 8),
    Hero('Archer', 90, 10, 5),
    Hero('Mage', 80, 8, 3)
  ];
  var mobList = [
    Mob('Goblin', 80, 20),
    Mob('Orc', 65, 30),
    Mob('Slime', 70, 25)
  ];

  // Memilih karakter Hero oleh user
  print('Pilih karakter Hero:');
  for (var i = 0; i < heroList.length; i++) {
    var hero = heroList[i];
    print('$i. ${hero.name} - Attack: ${hero.attack}, Health: ${hero.health}, Defense: ${hero.defense}');
  }
  var heroChoice = int.parse(stdin.readLineSync()!);

  // Memilih karakter Mob oleh user
  print('Pilih karakter Mob:');
  for (var i = 0; i < mobList.length; i++) {
    var mob = mobList[i];
    print('$i. ${mob.name} - Attack: ${mob.attack}, Health: ${mob.health}');
  }
  var mobChoice = int.parse(stdin.readLineSync()!);

  var hero = heroList[heroChoice];
  var mob = mobList[mobChoice];

  bool isBattleFinished = false;

  Future<void> startBattle() async {
    while (!isBattleFinished && hero.health > 0 && mob.health > 0) {
      // Hero menyerang Mob
      await hero.serang(mob);
      // Memeriksa apakah Mob masih hidup sebelum Mob menyerang Hero
      if (mob.health <= 0) {
        isBattleFinished = true;
        break;
      }


      // Mob menyerang Hero
      await mob.serang(hero);
      // Memeriksa apakah Hero masih hidup setelah serangan Mob
      if (hero.health <= 0) {
        isBattleFinished = true;
        break;
      }

      // Menampilkan kesehatan setelah serangan
      print('Kesehatan ${hero.name}: ${hero.health}');
      print('Kesehatan ${mob.name}: ${mob.health}');
    }
  }

  startBattle();
}
