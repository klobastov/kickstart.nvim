# kickstart-modular.nvim

## Instalation
* `:Mason`
* install `phpactor` as LSP, install `php-cs-fixer` as Formatter
* `composer global require --dev phpstan/phpstan`
* apply tricks

## Tricks

If php-cs-fixer is in $PATH, you don't need to define line below
`ln -s ~/.local/share/nvim/mason/packages/php-cs-fixer/php-cs-fixer ~/.local/bin/php-cs-fixer`

*PhpActor*
`ln -s ~/.local/share/nvim/mason/packages/phpactor/phpactor ~/.local/bin/phpactor`
*php-cs-fier**
`ln -s ~/.local/share/nvim/mason/packages/php-cs-fixer/php-cs-fixer.phar ~/.local/bin/php-cs-fixer.phar`
*PhpStan**
`ln -s ~/.config/composer/vendor/bin/phpstan ~/.local/bin/phpstan`

## Description

PhpActor used php-cs-fixer via LSP for auto formatting. But for able to see warrnigns PhpActor used same binary, chosen in .phpactor config.
PhpActor also used PhpStan from global composer package instalation.
