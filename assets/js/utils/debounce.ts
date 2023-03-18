/**
 * Debounce a function
 *
 * @param fn Funtion to call when not debouncing
 * @param timeout time in milliseconds to wait after call (300ms default)
 * @returns debounced function
 */
function debounce(fn: Function, timeout = 300) {
  let timeoutId: ReturnType<typeof setTimeout>;

  return function (this: any, ...args: any[]) {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => fn.apply(this, args), timeout);
  };
};

export { debounce };
