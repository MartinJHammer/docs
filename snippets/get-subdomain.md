// FUNCTION
declare const window: Window;

/**
 * Gets the current url's subdomain
 *
 * If you need this functionality in AngularJS (platform-legacy), use
 * SharedService.getSubDomain() @
 * apps/platform-legacy/src/appjs/shared/shared.service.ts
 *
 * @returns The subdomain as a string. If no subdomain, an empty string is returned.
 */
export const getSubdomain = (): string => {
  // Split the url
  const splittedHostName = window.location.hostname
    .split('.')
    // Remove the 'www' as that is not a "subdomain".
    .filter((x) => x !== 'www');

  // if the splitted hostname has 3 parts, the first part is a subdomain
  if (splittedHostName.length === 3) {
    return splittedHostName[0];
  } else {
    return '';
  }
};

// SPEC FILE

import { getSubdomain } from './get-subdomain';
declare const window: Window;
describe('getSubdomain', () => {
  const wikipedia = 'https://en.wikipedia.org/wiki/Wikipedia';
  const stackoverflow =
    'https://stackoverflow.com/questions/881085/count-the-number-of-occurrences-of-a-character-in-a-string-in-javascript';
  const google = 'https://www.google.com/';
  const wwwAndSubdomain = 'https://www.does-anybody-do-this.google.com/';

  const setWindowLocation = (url: string) => {
    delete window.location;
    // window.location.assign / replace does not work here.
    // Replacing location with URL is the recommended way
    // to mock location for unit tests (according to my reseach)
    window.location = Object.assign(new URL(url), {
      ancestorOrigins: '',
      assign: jest.fn(),
      reload: jest.fn(),
      replace: jest.fn()
    }) as any;
  };

  beforeEach(() => {
    expect.hasAssertions();
  });

  it('should get the subdomain of an url with a subdomain', () => {
    setWindowLocation(wikipedia);
    expect(getSubdomain()).toBe('en');
  });

  it('should return empty string for an url with www or no subdomain', () => {
    setWindowLocation(stackoverflow);
    expect(getSubdomain()).toBe('');
  });

  it('should return empty string for an url with www', () => {
    setWindowLocation(google);
    expect(getSubdomain()).toBe('');
  });

  it('should return the subdomain, even if both www and a subdomain is present', () => {
    setWindowLocation(wwwAndSubdomain);
    expect(getSubdomain()).toBe('does-anybody-do-this');
  });
});