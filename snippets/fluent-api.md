// ================================ PART 1 ========================================

import { DebugElement } from '@angular/core';
import { ComponentChainable } from './component-chainable';
import { ComponentFixture } from '@angular/core/testing';
import { By } from '@angular/platform-browser';

/**
 * All a component page should do, is to get a ComponentChainable that wraps the DebugElement.
 */
export abstract class ComponentPage {
  fixture: ComponentFixture<unknown>;

  protected _getChainableForElement<T>(tag: string): T {
    return (this._factory(this._getByTag(tag)) as unknown) as T;
  }

  protected _getByTag(
    tag: string,
    attrName: 'test' | 'cy' = 'test'
  ): DebugElement {
    return this.fixture.debugElement.query(
      By.css(`[data-${attrName}="${tag}"]`)
    );
  }

  /**
   * Creates a new instance of the ComponentChainable without any debug element inside.
   * Used to get the chainable and run its functions when no DebugElement is involved.
   */
  abstract chainable(): ComponentChainable<ComponentPage>;

  /**
   * Creates a new instance of the ComponentChainable.
   * @param el$ The selected DebugElement
   */
  protected abstract _factory(
    el$: DebugElement
  ): ComponentChainable<ComponentPage>;
}



// ================================ PART 2 ========================================

import { DebugElement } from '@angular/core';
import { ComponentFixture, flush, tick } from '@angular/core/testing';
import { ComponentPage } from './component-page';

/**
 * A component chainable wraps a DebugElement and the ComponentPage that selected it.
 * The chainable class allows for easy, fluent testing
 */
export class ComponentChainable<Page extends ComponentPage> {
  protected _nativeElement: HTMLElement;
  protected _fixture: ComponentFixture<unknown>;

  constructor(protected el$: DebugElement, protected _page: Page) {
    this._nativeElement = el$?.nativeElement;
    this._fixture = _page.fixture;
  }

  /**
   * Use this to get the selected element(s) out of the chainable class
   * to do custom logic.
   */
  element(): DebugElement {
    return this.el$;
  }

  page() {
    return this._page;
  }

  click() {
    this._nativeElement.click();
    return this;
  }

  shouldExist() {
    expect(this.el$).toBeTruthy();
    return this;
  }

  shouldNotExist() {
    expect(this.el$).toBeFalsy();
    return this;
  }

  detectChanges() {
    this._fixture.detectChanges();
    return this;
  }

  tick() {
    tick();
    return this;
  }

  flush() {
    flush();
    return this;
  }
}


// ================================ PART 3 ========================================

import { DebugElement } from '@angular/core';
import { ComponentChainable } from '@ganintegrity/shared/testing';
import { Company } from '../../../company.typings';
import { RollupSettingsComponentPage } from './roll-up-settings-component.page';
import { RollUpSettingsComponent } from './../roll-up-settings.component';

export class RollupSettingsComponentChainable extends ComponentChainable<RollupSettingsComponentPage> {
  component: RollUpSettingsComponent;
  constructor(el$: DebugElement, page: RollupSettingsComponentPage) {
    super(el$, page);
    this.component = this._fixture.componentInstance as RollUpSettingsComponent;
  }

  setMockCompany(company: Company) {
    this.component.company = company;
    return this;
  }

  expectFormValueToBe(target: string, expectiation: any) {
    console.log(this.component);
    expect(this.component.form.value[target]).toStrictEqual(expectiation);
    return this;
  }

  addValidValuesToForm() {
    this.component.form.setValue({
      rollupEnabled: false,
      rollupCompanyAttributeId: 1,
      fallbackEmployeeAttributeExternalId: 'test'
    });
    return this;
  }

  setFormValue(target: string, value: unknown) {
    this.component.form.controls[target].setValue(value);
    return this;
  }
}

// ================================ PART 4 ========================================

import { DebugElement } from '@angular/core';
import { ComponentPage } from '@ganintegrity/shared/testing';
import { RollupSettingsComponentChainable } from './roll-up-settings-component-chainable';

export class RollupSettingsComponentPage extends ComponentPage {
  enabledCheckbox(): RollupSettingsComponentChainable {
    return this._getChainableForElement('gan-checkbox__input');
  }

  roleAttrSelectBox(): RollupSettingsComponentChainable {
    return this._factory(this._getByTag('gan-select', 'cy'));
  }

  fallbackValueSelectBox(): RollupSettingsComponentChainable {
    return this._getChainableForElement('paginated-select');
  }

  roleAttrOption(optionIndex: number): RollupSettingsComponentChainable {
    return this._getChainableForElement(`attr-${optionIndex}`);
  }

  fallBackOption(optionIndex: number): RollupSettingsComponentChainable {
    return this._getChainableForElement(`paginated-item-${optionIndex}`);
  }

  roleAttrErrorMessage(): RollupSettingsComponentChainable {
    return this._getChainableForElement(`rollup-attr-error-message`);
  }

  fallBackOptionErrorMessage(): RollupSettingsComponentChainable {
    return this._getChainableForElement(`fallback-attr-error-message`);
  }

  chainable(): RollupSettingsComponentChainable {
    return new RollupSettingsComponentChainable(undefined, this);
  }

  protected _factory(el$: DebugElement): RollupSettingsComponentChainable {
    return new RollupSettingsComponentChainable(el$, this);
  }
}


