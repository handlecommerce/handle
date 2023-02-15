
export interface ILiveViewHook {
  /**
   * Attribute referencing the bound DOM node
   */
  el: HTMLFormElement;

  /**
   * Attribute matching the DOM node's phx-view value
   */
  viewName: string;

  /**
   * The element has been added to the DOM and its server LiveView has finished mounting
   */
  mounted: () => void;

  /**
   * The element is about to be updated in the DOM. Note: any call here must be
   * synchronous as the operation cannot be deferred or cancelled
   */
  beforeUpdate: () => void;

  /**
   * The element has been updated in the DOM by the server
   */
  updated: () => void;

  /**
   * Method to handle an event pushed from the server
   */
  handleEvent: (event: string, callback: (payload: any) => void) => void;

  /**
   * the element is about to be removed from the DOM.
   *
   * Note: any call here must be synchronous as the operation cannot be deferred
   * or cancelled.
   */
  beforeDestroy: () => void;

  /**
   * The element has been removed from the page, either by a parent update, or
   * by the parent being removed entirely
   */
  destroyed: () => void;

  /**
   * The element's parent LiveView has disconnected from the server
   */
  disconnected: () => void;

  /**
   * The element's parent LiveView has reconnected to the server
   */
  reconnected: () => void;

  /**
   * Method to push an event from the client to the LiveView server
   */
  pushEvent: (event: string, payload: object) => void;

  /**
   * Method to push targeted events from the client to LiveViews and LiveComponents.
   */
  pushEventTo: (selector: string, event: string, payload: object) => void;
}
