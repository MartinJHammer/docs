```typescript
/**
   * A promise updated with multiple then's via addStep() function.
   * Used to ensure code is executed in expected order, and allowing
   * for a fluent API at the same time.
   */
  protected steps = Promise.resolve(null);

  /**
   * Updates the steps promise with a new then that executes the provided logic.
   * Returns this to enable a fluent API.
   */
  addStep(step: () => void | Promise<unknown>) {
    this.steps = this.steps.then(step);
    return this;
  }

  /**
   * Run and clear ALL steps.
   * Executes the promise containing all the steps added by calling this clas's methods.
   */
  async run() {
    await this.steps;
    this.steps = Promise.resolve(null);
    return Promise.resolve(null);
  }

--- BUILD STEPS ---
  someStep(getter: Promise<TestElement>) {
    return this.addStep(() =>
      getter.then((testElement) => (this.testElement = testElement))
    );
  }