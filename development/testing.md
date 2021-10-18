# Testing

## Flow
- Write failing test cases.
- Prep stuff: Components, Services, Data, State, Helpers, Test types
    > Helpers: Test data generator, Array tester
- Before each, After each, etc.
- Write code -> Rewrite test to succeed.

## What to test
- Sanity: Is created, is of type, has properties, etc.
- Methods, Streams, Services (parts work)
- Components (works in isolation)
- E2E (works in context)
- Immutability
- Error handling + messages
- State changes (initial, result(s), error, success, waiting)

## Good references
- content-translation-card.component.spec.ts
- memoizer.spec.ts
- pagination-handler.spec.ts

## GAN test commands
`npx nx run data-integration-service-feature-admin-config:test --detectOpenHandles --runInBand`
OR RUN
`npx nx test data-integration-service-feature-admin-config`

## Notes
- Fuck snaphots.
- Use PageObjects (grouped selectors)
- Use Fluent interface pattern (Chainable)
    > Chainable -> DomainChainable
    > Page -> DomainPage
- Use factory pattern
- Use Harness / PageObjects.
- 100% testing is not needed. Cover what matters.

## Test snippets
```typescript
/*
    === Mocks === 
*/

// Simply service/class mock: Cast object literal
function getMockedHttpClient(value: string[]): HttpClient {
  return ({ get: jest.fn(() => of(value)) } as unknown) as HttpClient;
}

// Advanced service/class mock: Create class and replace via useClass
providers: [{
    provide: HttpClient,
    useClass: MockedHttpClient
}]

/*
    === Expects === 
*/
expect.hasAssertions();
expect().toBeDefined() // Good for sanity checks
expect().toThrow() // Errors thrown
expect().toMatchObject({}) // Match on object structure + values
expect(spy).toHaveBeenCalledWith('someParam1', 'someParam2') // Check if spied method was called with params.
expect(promise).toBeInstanceOf(Promise); // If reference is of instance
export().toStrictEqual() // Use to test that objects have the same types as well as structure.


/*
    === Time savers === 
*/
// Each
 it.each<any>([
    [[], false],
    [[[]], true]
])('', (something, expected, done) => {
    expect(result).toBe(expected);
    done();
});

/*
    === Jest ===
*/
jest.spyOn(someClass, 'someMethod') // Get a spy to run expect()'s on.

/*
    === Angular ===
*/
// Harness
export class RequestInfoComponentHarness extends ComponentHarness {
  static hostSelector = 'app-request-info';
  protected getTitle = this.locatorFor('h2');
  protected getButton = this.locatorFor('button[type=submit]');
  protected getInput = this.attrLocator('address');Q
  protected getLookupResult = this.attrLocator('lookup-result');

  async submit(): Promise<void> {
    const button = await this.getButton();
    return await button.click();
  }

  async writeAddress(address: string): Promise<void> {
    const input = await this.getInput();
    await input.clear();
    return await input.sendKeys(address);
  }

  async getResult(): Promise<string> {
    const p = await this.getLookupResult();
    return p.text();
  }

  protected attrLocator(tag: string): AsyncFactoryFn<TestElement> {
    return this.locatorFor(`[data-test=${tag}]`);
  }
}
// In the test
const harness = await TestbedHarnessEnvironment.harnessForFixture(
    fixture,
    RequestInfoComponentHarness
);
await harness.writeAddress('Domgasse 15');
await harness.submit();
const message = await harness.getResult();
expect(message).toBe('Address not found');
await harness.writeAddress('Domgasse 5');
await harness.submit();
return expect(harness.getResult()).resolves.toBe('Brochure sent');

// Other stuff in angular
fixture.detectChanges(); // Run change detection
fixture.componentInstance.search(); // Any component method
fixture.debugElement.query(By.css('[data-test=lookup-result]')).nativeElement as HTMLElement; // Manual html element getter
waitForAsync(() => {}) // Means you can skip 'await' on promises, or manually calling done().

```