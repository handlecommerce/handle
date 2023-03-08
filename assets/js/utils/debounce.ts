/**
 * Debounce a function
 *
 * @param fn Funtion to call when not debouncing
 * @param milliseconds time in milliseconds to wait after call
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
