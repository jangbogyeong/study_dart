import 'dart:io';
import 'dart:math';

// 캐릭터 클래스 정의
class Character {
  String name;
  int health;
  int attack;
  int defense;
  bool isDefending = false;

  Character(this.name, this.health, this.attack, this.defense);

  // 몬스터 공격 메서드
  void attackMonster(Monster monster) {
    int damage = attack;
    monster.health -= damage;
    print('$name이(가) ${monster.name}에게 $damage의 데미지를 입혔습니다.');
  }

  void defend(Monster monster) {
    isDefending = true;
    int heal = monster.attackPower; // 몬스터의 공격력만큼 회복
    health += heal;
    print('$name이(가) 방어 태세를 취하여 ${monster.name}의 공격력만큼($heal) 체력을 회복했습니다.');
  }

  // 상태 출력 메서드
  void showStatus() {
    print('$name - 체력: $health, 공격력: $attack, 방어력: $defense');
  }
}

// 몬스터 클래스 정의
class Monster {
  String name;
  int health;
  late int attackPower;
  final int defense = 0;

  Monster(this.name, this.health, int maxAttackPower, Character character) {
    // 공격력이 캐릭터의 방어력보다 작을 수 없음
    attackPower =
        maxAttackPower > character.defense ? maxAttackPower : character.defense;
  }

  // 캐릭터 공격 메서드
  void attackCharacter(Character character) {
    int damage = attackPower - character.defense;
    if (damage < 0) damage = 0;
    character.health -= damage;
    print('${name}이(가) ${character.name}에게 $damage의 데미지를 입혔습니다.');
  }

  // 상태 출력 메서드
  void showStatus() {
    print('$name - 체력: $health, 공격력: $attackPower');
  }
}

// 게임 클래스 정의
class Game {
  Character? character;
  List<Monster> monsters = [];
  int defeatedMonsters = 0;

  // 캐릭터 이름 입력 받기
  String getCharacterName() {
    while (true) {
      print('캐릭터의 이름을 입력하세요:');
      String? input = stdin.readLineSync();

      if (input == null || input.isEmpty) {
        print('이름을 입력해주세요.');
        continue;
      }

      RegExp nameRegex = RegExp(r'^[a-zA-Z가-힣]+$');
      if (!nameRegex.hasMatch(input)) {
        print('이름에는 한글과 영문만 사용할 수 있습니다.');
        continue;
      }

      return input;
    }
  }

  // 캐릭터 스탯 로드
  void loadCharacterStats() {
    try {
      final file = File('characters.txt');
      if (!file.existsSync()) {
        throw FileSystemException('characters.txt 파일을 찾을 수 없습니다.');
      }

      final contents = file.readAsStringSync().trim();
      final stats = contents.split(',');
      if (stats.length != 3) {
        throw FormatException('캐릭터 데이터 형식이 잘못되었습니다. (체력,공격력,방어력 형식이어야 합니다)');
      }

      int health = int.parse(stats[0].trim());
      int attack = int.parse(stats[1].trim());
      int defense = int.parse(stats[2].trim());

      String name = getCharacterName();
      character = Character(name, health, attack, defense);
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      print('기본 스탯으로 게임을 시작합니다.');
      String name = getCharacterName();
      character = Character(name, 50, 10, 5);
    }
  }

  // 몬스터 스탯 로드
  void loadMonsterStats() {
    try {
      final file = File('monsters.txt');
      if (!file.existsSync()) {
        throw FileSystemException('monsters.txt 파일을 찾을 수 없습니다.');
      }

      final lines = file.readAsLinesSync();
      monsters.clear();

      for (String line in lines) {
        final stats = line.trim().split(',');
        if (stats.length != 3) continue;

        try {
          String name = stats[0].trim();
          int health = int.parse(stats[1].trim());
          int maxAttack = int.parse(stats[2].trim());

          if (character != null) {
            monsters.add(Monster(name, health, maxAttack, character!));
          }
        } catch (e) {
          continue;
        }
      }

      if (monsters.isEmpty) {
        throw Exception('유효한 몬스터 데이터가 없습니다.');
      }
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      print('기본 몬스터로 게임을 시작합니다.');

      if (character != null) {
        monsters = [
          Monster('Spiderman', 20, 30, character!),
          Monster('Batman', 30, 20, character!),
          Monster('Superman', 30, 10, character!),
        ];
      }
    }
  }

  // 랜덤 몬스터 선택
  Monster? getRandomMonster() {
    if (monsters.isEmpty) return null;
    int index = Random().nextInt(monsters.length);
    return monsters[index];
  }

  // 전투 진행
  bool battle() {
    Monster? monster = getRandomMonster();
    if (monster == null || character == null) return false;

    print('\n새로운 몬스터가 나타났습니다!');
    monster.showStatus();

    while (monster.health > 0 && character!.health > 0) {
      // 플레이어 턴
      print('\n${character!.name}의 턴');
      print('행동을 선택하세요 (1: 공격, 2: 방어):');

      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          character!.attackMonster(monster);
          character!.isDefending = false; // 공격 시 방어 상태 해제
          break;
        case '2':
          character!.defend(monster); // monster 인자 전달
          break;
        default:
          print('잘못된 선택입니다.');
          continue;
      }

      if (monster.health <= 0) {
        print('\n${monster.name}을(를) 물리쳤습니다!');
        monsters.remove(monster);
        defeatedMonsters++;
        return true;
      }

      // 몬스터 턴
      print('\n${monster.name}의 턴');
      monster.attackCharacter(character!);
      character!.isDefending = false; // 몬스터 턴 후 방어 상태 해제

      // 현재 상태 출력
      character!.showStatus();
      monster.showStatus();

      if (character!.health <= 0) {
        print('\n${character!.name}이(가) 쓰러졌습니다...');
        return false;
      }
    }
    return false;
  }

  // 게임 결과 저장
  void saveResult(bool victory) {
    print('결과를 저장하시겠습니까? (y/n)');
    String? choice = stdin.readLineSync()?.toLowerCase();

    if (choice == 'y' && character != null) {
      try {
        final file = File('result.txt');
        file.writeAsStringSync(
          '캐릭터 이름: ${character!.name}\n'
          '남은 체력: ${character!.health}\n'
          '게임 결과: ${victory ? "승리" : "패배"}\n'
          '물리친 몬스터 수: $defeatedMonsters',
        );
        print('결과가 저장되었습니다.');
      } catch (e) {
        print('결과 저장에 실패했습니다: $e');
      }
    }
  }

  // 게임 시작
  void startGame() {
    loadCharacterStats();
    loadMonsterStats();

    while (true) {
      if (character == null || character!.health <= 0) {
        saveResult(false);
        print('게임 오버!');
        break;
      }

      if (monsters.isEmpty) {
        print('축하합니다! 모든 몬스터를 물리쳤습니다.');
        saveResult(true);
        break;
      }

      bool battleResult = battle();

      if (battleResult && !monsters.isEmpty) {
        print('\n다음 몬스터와 싸우시겠습니까? (y/n)');
        String? choice = stdin.readLineSync()?.toLowerCase();
        if (choice != 'y') {
          print('게임을 종료합니다.');
          saveResult(true);
          break;
        }
      }
    }
  }
}

void main() {
  Game game = Game();
  game.startGame();
}
