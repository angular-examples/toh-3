@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/src/hero.dart';
import 'package:angular_tour_of_heroes/src/hero_detail_component.dart';
import 'package:test/test.dart';

import 'hero_detail_po.dart';

const targetHero = const {'id': 1, 'name': 'Alice'};

NgTestFixture<HeroDetailComponent> fixture;
HeroDetailPO po;

@AngularEntrypoint()
void main() {
  final testBed = new NgTestBed<HeroDetailComponent>();

  tearDown(disposeAnyRunningTest);

  group('No initial @Input() hero:', () {
    setUp(() async {
      fixture = await testBed.create();
      po = await fixture.resolvePageObject(HeroDetailPO);
    });

    test('has empty view', () async {
      expect(fixture.rootElement.text.trim(), '');
      expect(await po.heroFromDetails, isNull);
    });

    test('transition to ${targetHero['name']} hero', () async {
      fixture.update((comp) {
        comp.hero = new Hero(targetHero['id'], targetHero['name']);
      });
      po = await fixture.resolvePageObject(HeroDetailPO);
      expect(await po.heroFromDetails, targetHero);
    });
  });

  group('${targetHero['name']} initial @Input() hero:', () {
    final Map updatedHero = {'id': targetHero['id']};

    setUp(() async {
      fixture = await testBed.create(
          beforeChangeDetection: (c) =>
              c.hero = new Hero(targetHero['id'], targetHero['name']));
      po = await fixture.resolvePageObject(HeroDetailPO);
    });

    test('show hero details', () async {
      expect(await po.heroFromDetails, targetHero);
    });

    test('update name', () async {
      const nameSuffix = 'X';
      updatedHero['name'] = "${targetHero['name']}$nameSuffix";
      await po.type(nameSuffix);
      expect(await po.heroFromDetails, updatedHero);
    });

    test('change name', () async {
      const newName = 'Bobbie';
      updatedHero['name'] = newName;
      await po.clear();
      await po.type(newName);
      expect(await po.heroFromDetails, updatedHero);
    });
  });
}
