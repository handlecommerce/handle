import * as monaco from 'monaco-editor';
import { Hook, makeHook } from "phoenix_typed_hook";
import { LivePreview } from '../components/live-preview';

import { debounce } from '../utils/debounce';

type IModelContentChangedEvent = monaco.editor.IModelContentChangedEvent;

// Since packaging is done by you, you need
// to instruct the editor how you named the
// bundles that contain the web workers.
window.MonacoEnvironment = {
  getWorkerUrl: function (_moduleId, label) {
    // if (label === 'json') {
    //   return './json.worker.bundle.js';
    // }
    // if (label === 'css' || label === 'scss' || label === 'less') {
    //   return './css.worker.bundle.js';
    // }
    if (label === 'html' || label === 'handlebars' || label === 'razor') {
      return '/assets/node_modules/monaco-editor/esm/vs/language/html/html.worker.js';
    }
    // if (label === 'typescript' || label === 'javascript') {
    //   return './ts.worker.bundle.js';
    // }

    return "/assets/node_modules/monaco-editor/esm/vs/editor/editor.worker.js"
  }
};

interface IBufferState {
  model: monaco.editor.IModel;
  viewState: monaco.editor.ICodeEditorViewState | null;
}

class MonacoEditor extends Hook {
  private editor: monaco.editor.IStandaloneCodeEditor;
  private focusedBufferId?: string;
  private buffers: Map<string, IBufferState>;

  private get focusedBuffer(): IBufferState | undefined {
    if (!this.focusedBufferId) {
      return undefined;
    }

    return this.buffers.get(this.focusedBufferId);
  }

  mounted() {
    // Start with a clean set of buffers
    this.buffers = new Map();

    // Bind all the events pushed from the server
    this.handleEvent("load-buffer", ({ id, content, language }) => this.loadBuffer(id, content, language));
    this.handleEvent("focus-buffer", ({ id }) => this.focusBuffer(id));
    this.handleEvent("close-buffer", ({ id }) => this.closeBuffer(id));
    this.handleEvent("display-preview", ({ content }) => {
      const previewElement = document.getElementsByTagName("live-preview")[0] as LivePreview | undefined;

      if (previewElement) {
        previewElement.content = content;
      }
    })

    // Create the default editor
    this.editor = monaco.editor.create(this.el, {
      language: "html",
      scrollBeyondLastLine: false,
      automaticLayout: true
    });

    this.editor.onDidChangeModelContent(debounce((e: IModelContentChangedEvent) => {
      const content = this.editor.getModel()?.getValue();
      this.pushEvent("generate-preview", { content })
    }));

    // Add a save action with CMD/CTRL-S
    this.editor.addAction({
      id: "Save Asset",
      label: "Save Asset",
      keybindings: [
        // tslint:disable-next-line: no-bitwise
        monaco.KeyMod.CtrlCmd | monaco.KeyCode.KeyS
      ],
      run: () => this.save()
    });

    window.addEventListener("resize", () => this.editor.layout());
  }

  /**
   * Save the content of the current buffer
   */
  private save() {
    const content = this.editor.getValue();
    this.pushEvent("save-buffer", { id: this.focusedBufferId, content })
  }

  /**
   * Store the currently focused buffer's viewstate
   */
  private storeCurrentState() {
    // Save off our view state
    if (this.focusedBuffer) {
      this.focusedBuffer.viewState = this.editor.saveViewState();
    }
  }

  private loadBuffer(id: string, content: string, language: string) {
    this.storeCurrentState();

    const model = monaco.editor.createModel(content, language);
    this.buffers.set(id, { model, viewState: null });

    this.focusBuffer(id);
  }

  /**
   * Focus a buffer by the given ID
   *
   * @param id Buffer ID to focus
   */
  private focusBuffer(id: string) {
    this.storeCurrentState();

    const bufferState = this.buffers.get(id);

    if (bufferState) {
      this.focusedBufferId = id;
      this.editor.setModel(bufferState.model);
      this.editor.restoreViewState(bufferState.viewState);
      this.editor.focus();

      this.pushEvent("generate-preview", { content: bufferState.model?.getValue() })
    }
  }

  /**
   * Close a buffer
   *
   * @param id Buffer ID to close
   */
  private closeBuffer(id: string) {
    this.buffers.delete(id);
  }
}

export default makeHook(MonacoEditor);
